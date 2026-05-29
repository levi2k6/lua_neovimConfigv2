local on_attach = require("plugin.lsp.lspKeymap")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("clangd", {
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = {
		"clangd",
		"--background-index",
		"--clang-tidy",
		"--header-insertion=iwyu",
		"--completion-style=detailed",
	},
	filetypes = { "c", "cpp", "objc", "objcpp" },
	root_markers = {
		"compile_commands.json",
		"compile_flags.txt",
		".git",
	},
})
