local map = vim.keymap.set

-- general keymaps

map('n', '<leader>e', ':Neotree toggle<CR>')


-- better window navigation
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

-- resize with arrows
map('n', '<C-Up>', ':resize -2<CR>')
map('n', '<C-Down>', ':resize +2<CR>')
map('n', '<C-Left>', ':res -2<CR>')
map('n', '<C-Right>', ':res +2<CR>')


-- move selected lines up and down in visual mode
map('v', 'J', ":m '>+1<CR>gv=gv")
map('v', 'K', ":m '<-2<CR>gv=gv")

-- better terminal experience
map('t', '<Esc>', [[<C-\><C-n>]])           -- exit terminal mode
map('n', '<leader>t', ':vsplit | term<CR>') -- open a terminal in a vertical split

-- buffer management
map('n', '<S-l>', ':bnext<CR>')       -- next buffer
map('n', '<S-h>', ':bprevious<CR>')   -- previous buffer
map('n', '<leader>d', ':bdelete<CR>') -- close buffer

map('n', '<leader>de', ':Telescope diagnostics<CR>', { desc = 'Project Diagnostics' })

map('n', '<leader>fs', ':Telescope current_buffer_fuzzy_find<CR>', { desc = 'Find in Current Buffer' })