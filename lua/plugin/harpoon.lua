return {
    "ThePrimeagen/harpoon",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local mark = require("harpoon.mark")
        local ui = require("harpoon.ui")

        require("harpoon").setup({
            global_settings = {
                save_on_toggle = true,
                save_on_change = true,
                enter_on_sendcmd = false,
                excluded_filetypes = { "harpoon", "terminal" },
            },
        })

        -- menu
        vim.keymap.set("n", "<leader>hh", function() ui.toggle_quick_menu() end,  { desc = "Harpoon: Quick Menu" })

        -- add/remove current file (harpoon's intended workflow)
        vim.keymap.set("n", "<leader>ha", function() mark.add_file() end,          { desc = "Harpoon: Add file" })
        vim.keymap.set("n", "<leader>hd", function() mark.rm_file() end,           { desc = "Harpoon: Remove file" })
        vim.keymap.set("n", "<leader>hc", function() mark.clear_all() end,         { desc = "Harpoon: Clear all" })

        -- navigate
        for i = 1, 9 do
            vim.keymap.set("n", "<leader>" .. i, function()
                -- guard: don't navigate from a terminal buffer
                if vim.bo.buftype == "terminal" then
                    vim.notify("Harpoon: can't navigate from terminal", vim.log.levels.WARN)
                    return
                end
                ui.nav_file(i)
            end, { desc = "Harpoon: Go to file " .. i })
        end

        -- prev/next cycling (harpoon's intended navigation)
        vim.keymap.set("n", "<leader>hp", function() ui.nav_prev() end, { desc = "Harpoon: Prev" })
        vim.keymap.set("n", "<leader>hn", function() ui.nav_next() end, { desc = "Harpoon: Next" })
    end
}
