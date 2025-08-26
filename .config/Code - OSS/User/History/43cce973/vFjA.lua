return {
  -- core plugins
  'folke/lazy.nvim',
  'nvim-lua/plenary.nvim',

  -- ui
  { import = 'ryu.plugins.ui' },

  -- lsp & development
  { import = 'ryu.plugins.lsp' },
}