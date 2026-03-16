local on_attach = require("plugin.lsp.lspKeymap").on_attach
local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("dartls", {
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = { "dart", "language-server", "--protocol=lsp" },
	filetypes = { "dart" },
	root_markers = {"pubspec.yaml"},
	settings = {
		dart = {
			completeFunctionCalls = true,
			showTodos = true,
		},
	},
})

vim.lsp.enable("dartls")
