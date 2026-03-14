return{
	"nvim-telescope/telescope.nvim",
	dependencies = {"nvim-lua/plenary.nvim"},
	config = function()
		require("telescope").setup({
			defaults = {
				hidden = true,
				no_ignore = true
			}
		})

		local builtin = require("telescope.builtin")

		vim.keymap.set("n", "<leader><leader>", builtin.find_files, {}) 
		vim.keymap.set("n", "<leader>ff", builtin.live_grep, {})
		vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
		vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
		vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find, {})
	end
}
