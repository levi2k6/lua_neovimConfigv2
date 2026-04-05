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
    end
}
