return {
  -- Colorscheme
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  -- Status Line
  { 'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' } },
  -- File Explorer
  { 'nvim-tree/nvim-tree.lua', dependencies = { 'nvim-tree/nvim-web-devicons' } },
  -- Load our custom plugin configs
  require('plugins.colorscheme'),
  require('plugins.lualine'),
  require('plugins.nvim-tree'),
}