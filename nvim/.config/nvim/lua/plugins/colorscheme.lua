return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = true,
        term_colors = false,
      })
    end
  },
  {
    "folke/tokyonight.nvim",
    name = "tokyonight",
    priority = 1000,
    opts = {},
    config = function()
      require("tokyonight").setup({
        style = "night",
        styles = {
          sidebars = "transparent",
          floats = "transparent",
        },
        transparent = true,
      })
      vim.cmd [[colorscheme tokyonight]]
    end
  }
}
