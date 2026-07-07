vim.pack.add({ "https://github.com/folke/tokyonight.nvim" })

require("tokyonight").setup({
  style = "storm",
  styles = {
    sidebars = "transparent",
    floats = "transparent",
  },
  transparent = true,
  on_colors = function(_) end,
  on_highlights = function(_) end,
})
vim.cmd('colorscheme tokyonight')
