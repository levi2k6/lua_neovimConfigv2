
return {
	on_attach = function(client, bufnr)
		local opts = {buffer = bufnr, silent = true, noremap = true}
		vim.keymap.set("n", "<leader>ee", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "<leader>ew", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "<leader>ei", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "<leader>ed", vim.lsp.buf.type_definition, opts)

		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)

		vim.keymap.set("n", "<leader>ef", function() vim.lsp.format({async = true}) end, opts)
	end
}

