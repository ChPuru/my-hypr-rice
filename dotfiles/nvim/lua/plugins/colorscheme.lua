-- This file is intentionally left simple.
-- The theme is set by a global variable to be replaced by our theme.sh script.
-- This is a workaround for templating inside Lua.
vim.g.nvim_theme = "catppuccin"

return {
  config = function()
    require(vim.g.nvim_theme).setup({
      transparent_background = true,
    })
    vim.cmd.colorscheme(vim.g.nvim_theme)
  end,
}