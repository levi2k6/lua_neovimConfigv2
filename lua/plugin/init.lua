local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end	

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	require("plugin.treesitter"),
	require("plugin.telescope"),
	require("plugin.lsp.lsp"),
	require("plugin.completion"),
	require("plugin.harpoon"),
	require("plugin.style"),
	require("plugin.oil"),
	require("plugin.noice"),
})

