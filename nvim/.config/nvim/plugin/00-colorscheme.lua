vim.pack.add({ 'https://github.com/folke/tokyonight.nvim' })

require("tokyonight").setup({
  style = "storm",
  styles = {
    sidebars = "transparent",
    floats = "transparent",
  },
  transparent = true,
  on_colors = function(colors) end,
  on_highlights = function(hl) end,
})
vim.cmd([[colorscheme tokyonight]])
