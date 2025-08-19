-- Keymaps
local map = vim.keymap.set

-- Normal Mode
map('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = "Toggle file explorer" })
map('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { desc = "Find files" })
map('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { desc = "Live grep" })

-- Visual Mode
map('v', 'J', ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map('v', 'K', ":m '<-2<CR>gv=gv", { desc = "Move line up" })