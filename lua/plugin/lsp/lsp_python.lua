local on_attach = require("plugin.lsp.lspKeymap")
local capabilities = require("cmp_cmp_lsp").default_capabilities()

vim.lsp.config("pyright", {
	on_attach = on_attach,
	capabilities = capabilities,
	before_init = function(_, config)
		local cwd = vim.fn.getcwd()

		local venvPaths = {"venv/bin/python", ".venv/bin/python"}

		for _, path in ipairs(venvPaths) do
			local fullPath = cwd .. "/" .. path
			if vim.fn.filereadable(fullPath) == 1 then
				config.settings.python.pythonPath = fullPath
				return
			end
		end

		config.settings.pyton.pythonPath = vim.fn.exepath("python3")
	end
})

vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*.py",
    callback = function()
        -- Check if this is a newly created file
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        for _, client in ipairs(clients) do
            if client.name == "pyright" then
                -- Notify the server about the workspace change
                client.notify("workspace/didChangeWatchedFiles", {
                    changes = {
                        {
                            uri = vim.uri_from_bufnr(0),
                            type = 1 -- Created
                        }
                    }
                })
            end
        end
    end,
})








