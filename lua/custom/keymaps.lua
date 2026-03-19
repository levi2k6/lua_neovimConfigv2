vim.g.mapleader = " "
vim.keymap.set("n", "<C-j>", "<cmd>e#<CR>", {noremap=true, silent=true})
vim.keymap.set("t", "<C-j>", "<cmd>e#<CR>", {noremap=true, silent=true})
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], {noremap=true, silent=true})
--copy clipboard
vim.keymap.set({"n", "v"}, "<leader>y", '"+y')
vim.keymap.set("n", "<leader>yy", '"+yy')
-- paste clipboard
vim.keymap.set("n", "<leader>p", '"+p')
vim.keymap.set("n", "<leader>P", '"+P')
vim.keymap.set("v", "<leader>p", '"+p')


-- Center after jumping to previous position (the '' and `` marks)
vim.keymap.set('n', '<C-o>', '<C-o>zz', { noremap = true, silent = true })
vim.keymap.set('n', '<C-i>', '<C-i>zz', { noremap = true, silent = true })

-- Center after jumping to specific marks
vim.keymap.set('n', "'", function()
  return "'" .. vim.fn.nr2char(vim.fn.getchar()) .. 'zz'
end, { noremap = true, expr = true, silent = true })

vim.keymap.set('n', '`', function()
  return '`' .. vim.fn.nr2char(vim.fn.getchar()) .. 'zz'
end, { noremap = true, expr = true, silent = true })
