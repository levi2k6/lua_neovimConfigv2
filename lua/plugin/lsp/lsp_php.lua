local on_attach = require("plugin.lsp.lspKeymap").on_attach
local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("intelephense", {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    intelephense = {
      files = {
        maxSize = 5000000,
      },
      environment = {
        phpVersion = "8.3", -- change to your PHP version
      },
      diagnostics = {
        enable = true,
      },
      -- Optional: add stubs if you need WordPress, Laravel helpers, etc.
      -- stubs = { "wordpress", "woocommerce", "laravel" },
    },
  },
})

vim.lsp.enable("intelephense")
