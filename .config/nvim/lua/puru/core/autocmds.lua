local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- highlight on yank
augroup('HighlightYank', { clear = true })
autocmd('TextYankPost', {
  group = 'HighlightYank',
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({
      higroup = 'IncSearch',
      timeout = 200,
    })
  end,
})