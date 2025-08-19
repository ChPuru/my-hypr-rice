-- This file lists all the plugins to be managed by lazy.nvim
return {
  -- Colorscheme
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  { "folke/tokyonight.nvim", name = "tokyonight", priority = 1000 },
  
  -- Status Line
  { 'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' } },

  -- File Explorer
  { 'nvim-tree/nvim-tree.lua', dependencies = { 'nvim-tree/nvim-web-devicons' } },

  -- Fuzzy Finder
  { 'nvim-telescope/telescope.nvim', tag = '0.1.5', dependencies = { 'nvim-lua/plenary.nvim' } },

  -- LSP, Mason, and Autocompletion
  { 'neovim/nvim-lspconfig' },
  { 'williamboman/mason.nvim' },
  { 'williamboman/mason-lspconfig.nvim' },
  { 'hrsh7th/nvim-cmp' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-path' },
  { 'L3MON4D3/LuaSnip' },
  { 'saadparwaiz1/cmp_luasnip' },

  -- Git Integration
  { 'lewis6991/gitsigns.nvim' },

  -- Load our custom plugin configs
  require('plugins.colorscheme'),
  require('plugins.lualine'),
  require('plugins.nvim-tree'),
  require('plugins.telescope'),
  require('plugins.lsp'),
}