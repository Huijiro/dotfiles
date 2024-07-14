return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300

    local wk = require("which-key")

    wk.add({
      { "<leader>f",  group = "Find" },
      { "<leader>t",  group = "Terminal" },
      { "<leader>h",  group = "Harpoon" },
      { "<leader>o",  group = "Optional Tools" },
      { "<leader>d",  group = "Debug" },
      { "<leader>x",  group = "Trouble" },
      { "<leader>w",  ":w<cr>",                desc = "Save" },
      { "<leader>q",  ":q<cr>",                desc = "Quit" },
      { "<leader>Q",  ":q!<cr>",               desc = "Force Quit" },
      { "<leader>b",  group = "Buffers" },
      { "<leader>bh", ":bprev<cr>",            desc = "Previous Buffer" },
      { "<leader>bl", ":bnext<cr>",            desc = "Next Buffer" },
      { "<leader>bc", ":bdelete<cr>",          desc = "Close Buffer" }
    })
  end,
}
