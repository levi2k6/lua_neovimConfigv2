return {
    "sudo-tee/opencode.nvim",
    config = function()
        require("opencode").setup({})
    end,
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "MeanderingProgrammer/render-markdown.nvim",
            opts = {
                anti_conceal = { enabled = false },
                file_types = { "markdown", "opencode_output" },
            },
            ft = { "markdown", "opencode_output" },
        },
        "hrsh7th/nvim-cmp",
        "nvim-telescope/telescope.nvim",
    },
}
