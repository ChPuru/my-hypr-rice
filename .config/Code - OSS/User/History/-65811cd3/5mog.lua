-- set leader key before anything else
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- load core modules
require('ryu.core.options')
require('ryu.core.keymaps')
require('ryu.core.autocmds')

-- setup lazy.nvim with your plugins
require('lazy').setup('ryu.plugins')