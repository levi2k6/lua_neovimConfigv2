return{
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = {"lua_ls", "pyright", "clangd"},
		})
		vim.diagnostic.config({
			virtual_text = true,
			sings = true,
			update_in_insert = false,
			serverity_sort = true,
		})
		require("plugin.lsp.lsp_lua")
		require("plugin.lsp.lsp_python")
		require("plugin.lsp.lsp_c_c++")
		require("plugin.lsp.lsp_dart")
	end
}
