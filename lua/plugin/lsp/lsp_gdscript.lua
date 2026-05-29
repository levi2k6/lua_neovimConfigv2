local on_attach = require("plugin.lsp.lspKeymap").on_attach
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local port = os.getenv("GDScript_Port") or "6005"

vim.lsp.config("gdscript", {
    cmd = vim.lsp.rpc.connect("127.0.0.1", tonumber(port)),
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "gd", "gdscript", "gdscript3" },
    root_markers = { "project.godot", ".git" },
})

vim.lsp.enable("gdscript")
