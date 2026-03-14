local on_attach = require("plugin.lsp.lspKeymap").on_attach
local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("lua_ls", {
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		Lua = {
			diagnostics = {globals = {"vim"}},
			workplace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
			telemetry = {enable = false },
		},
	},
})

vim.lsp.enable("lua_ls")
