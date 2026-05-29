return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
		require("nvim-treesitter.config").setup({
		  ensure_installed = {
			"lua",
			"python",
			"javascript",
			"typescript",
			"go",
			"c",
			'gdscript',
			'godot_resource',
			'gdshader',
		  },
		  auto_install = true,
		  highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		  },

		  indent = {
			enable = true,
		  },
		})
    end,
}

