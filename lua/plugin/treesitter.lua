return{
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").setup({
			ensure_installed = {"c", "cpp", "python", "go", "java"},
			highlight = {enable = true},
			indent = {enable=true}
		})
	end,
}
