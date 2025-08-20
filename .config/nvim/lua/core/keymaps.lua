local map = vim.keymap.set
vim.g.mapleader = " " -- Set space as the leader key
map('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = "Toggle file explorer" })