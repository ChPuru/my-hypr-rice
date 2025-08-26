return {
  config = function()
    require("catppuccin").setup({ flavor = "mocha" })
    vim.cmd.colorscheme("catppuccin")
  end,
}