return {
    "folke/noice.nvim",
    dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
    },
    config = function()
        require("noice").setup({
            timeout = 100,
            render = "minimal",
            background_colour = "#000000",
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_tomarkdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
                documentation = {          -- ← add this
                    mappings = {
                        scroll_up = "<C-u>",
                        scroll_down = "<C-d>",
                    },
                },
            },
            presents = {
                bottom_search = true,
                command_palette = true,
                long_message_to_split = true,
            },
        })
    end,
}
