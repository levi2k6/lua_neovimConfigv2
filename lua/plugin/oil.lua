return {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("oil").setup({
            default_file_explorer = true,
            view_options = {
                show_hidden = true,
            },
            keymaps = {
                ["<CR>"] = "actions.select",
                ["<BS>"] = "actions.parent",
                ["-"] = "actions.parent",
                ["_"] = "actions.open_cwd",
                ["q"] = "actions.close",
                ["<C-p>"] = "actions.preview",
            },
        })

        vim.keymap.set("n", "-", "<CMD>Oil<CR>", {})
    end,
}
