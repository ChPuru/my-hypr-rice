return {
  -- core plugins
  'folke/lazy.nvim',
  'nvim-lua/plenary.nvim',

  -- ui
  { import = 'puru.plugins.ui' },

  -- lsp & development
  { import = 'puru.plugins.lsp' },
}