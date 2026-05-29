return {
	"neovim/nvim-lspconfig",
	dependencies = {
	"williamboman/mason.nvim",
	"williamboman/mason-lspconfig.nvim",
	},
	config = function()
	require("mason").setup()
	require("mason-lspconfig").setup({
	  ensure_installed = { "lua_ls", "pyright", "clangd"},
	  automatic_enable = true,
	})
	vim.diagnostic.config({
	  virtual_text = true,
	  signs = true,
	  update_in_insert = false,
	  severity_sort = true,
	})
	require("plugin.lsp.lsp_lua")
	require("plugin.lsp.lsp_python")
	require("plugin.lsp.lsp_c_c++")
	require("plugin.lsp.lsp_dart")
	require("plugin.lsp.lsp_gdscript")
	end
}
