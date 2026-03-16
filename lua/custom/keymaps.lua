vim.g.mapleader = " "
vim.keymap.set("n", "<C-j>", "<cmd>e#<CR>", {noremap=true, silent=true})
vim.keymap.set("t", "<C-j>", "<cmd>e#<CR>", {noremap=true, silent=true})
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], {noremap=true, silent=true})
vim.keymap.set({"n", "x"}, "y", '"+y', {noremap=true, silent=true})
