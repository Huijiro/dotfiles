return {
  "huijiro/tmux-nav.nvim",
  opts = {
    switch_window = {
      enabled = true,
      modes = { "n", "i", "v", "x", "s" },
      keybinds = {
        { "<c-h>", "h" },
        { "<c-j>", "j" },
        { "<c-k>", "k" },
        { "<c-l>", "l" },
      },
    },
    resize = {
      enabled = true,
      modes = { "n" },
      amount = 2,
      keybinds = {
        { "<m-h>", "h" },
        { "<m-j>", "j" },
        { "<m-k>", "k" },
        { "<m-l>", "l" },
      },
    },
  },
  config = function(_, opts)
    require("tmux-nav").setup(opts)
  end,
}
