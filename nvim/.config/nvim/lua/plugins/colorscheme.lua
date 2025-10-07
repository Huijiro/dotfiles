return {
  {
    "folke/tokyonight.nvim",
    name = "tokyonight",
    lazy = false,
    priority = 1000,
    config = function()
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
    end
  }
}
