return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        "stevearc/oil.nvim",
    },
    config = function()
        require("telescope").setup({
            defaults = {
                hidden = true,
                no_ignore = true,
            },
        })

        require("telescope").load_extension("fzf")

        local builtin = require("telescope.builtin")
        vim.keymap.set("n", "<leader><leader>", builtin.find_files, {})
        vim.keymap.set("n", "<leader>ff", builtin.live_grep, {})
        vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
        vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
        vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find, {})

        local function open_folder_in_oil(prompt_bufnr)
            local selected = require("telescope.actions.state").get_selected_entry()
            require("telescope.actions").close(prompt_bufnr)
            if selected then
                local filepath = selected.path or selected.filename or selected.value
                local folder = vim.fn.fnamemodify(filepath, ":h")
                require("oil").open(folder)
            end
        end

        -- finds files, Enter opens the file's folder in oil
        vim.keymap.set("n", "<leader>fs", function()
            builtin.find_files({
                prompt_title = "Find File → Folder",
                attach_mappings = function(_, map)
                    map("n", "<CR>", open_folder_in_oil)
                    map("i", "<CR>", open_folder_in_oil)
                    return true
                end,
            })
        end, {})

        -- finds folders only, Enter opens folder in oil
        vim.keymap.set("n", "<leader>fd", function()
            builtin.find_files({
                prompt_title = "Find Folder",
                find_command = { "fd", "--type", "d" },
                attach_mappings = function(_, map)
                    map("n", "<CR>", open_folder_in_oil)
                    map("i", "<CR>", open_folder_in_oil)
                    return true
                end,
            })
        end, {})

        -- telescope picker limited to terminal buffers
        vim.keymap.set("n", "<leader>ft", function()
            local pickers = require("telescope.pickers")
            local finders = require("telescope.finders")
            local conf = require("telescope.config").values
            local actions = require("telescope.actions")
            local action_state = require("telescope.actions.state")

            local results = {}
            for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
                if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buftype == "terminal" then
                    local name = vim.api.nvim_buf_get_name(bufnr)
                    results[#results + 1] = { bufnr = bufnr, name = name }
                end
            end

            if #results == 0 then
                vim.notify("No terminal buffers", vim.log.levels.INFO)
                return
            end

            pickers.new({}, {
                prompt_title = "Terminal Buffers",
                finder = finders.new_table({
                    results = results,
                    entry_maker = function(entry)
                        local display = string.format("%d: %s", entry.bufnr, entry.name)
                        return {
                            value = entry,
                            display = display,
                            ordinal = display,
                            bufnr = entry.bufnr,
                        }
                    end,
                }),
                sorter = conf.generic_sorter({}),
                previewer = conf.grep_previewer({}),
                attach_mappings = function(prompt_bufnr)
                    actions.select_default:replace(function()
                        actions.close(prompt_bufnr)
                        local selection = action_state.get_selected_entry()
                        if not selection then
                            return
                        end
                        vim.api.nvim_set_current_buf(selection.bufnr)
                        vim.cmd("startinsert")
                    end)
                    return true
                end,
            }):find()
        end, { desc = "Telescope: Terminal buffers" })
    end
}
