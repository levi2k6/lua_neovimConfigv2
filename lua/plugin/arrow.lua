return {
	"otavioschwanck/arrow.nvim",
	dependencies = {"nvim-tree/nvim-web-devicons"},
	config = function()
		require("arrow").setup({
			leader_key = "<C-h>",
			mappings = {
				toggle = "s",
				open_vertical = "v",
				open_horizontal = "h",
				quit = "q",
			},
		})
	end
}
