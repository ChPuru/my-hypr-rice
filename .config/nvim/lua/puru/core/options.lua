local opt = vim.opt -- for conciseness

-- line numbers
opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

-- search settings
opt.ignorecase = true
opt.smartcase = true

-- behavior
opt.clipboard = 'unnamedplus'
opt.cursorline = true
opt.wrap = false

-- appearance
opt.termguicolors = true
opt.scrolloff = 8

-- search
opt.hlsearch = true  -- highlight all matches on search
opt.incsearch = true -- incremental search (show matches as you type)

-- undo
opt.undofile = true -- make undo history persistent

-- ui
opt.signcolumn = 'yes' -- always show the sign column to prevent text jumping
opt.list = true -- show some invisible characters
opt.listchars:append('tab:▸ ', 'trail:·', 'nbsp:·') -- what to show for them