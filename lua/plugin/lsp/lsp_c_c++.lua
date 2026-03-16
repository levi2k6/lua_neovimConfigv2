local on_attach = require("plugin.lsp.lspKeymap")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("clangd",{
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = {
		"clangd",
		"--background-index",
		"--clang-tidy",
		"--header-insertion=iwyu",
		"--completion-style=detailed",
	},
	filestypes = {"c", "cpp", "objc", "objcpp"},
	root_dir = function(fname)
		return require("lspconfig.util").root_pattern(
			"compile_commands.json",
			"compile_flags.txt",
			".git"
		)(fname)
	end,
})

vim.lsp.enable("clangd")
