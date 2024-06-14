return {
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    init = function()
      require("toggleterm").setup()

      vim.keymap.set('t', '<esc>', [[<C-\><C-n>]])
      vim.keymap.set('t', 'jk', [[<C-\><C-n>]])
      vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]])
      vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]])
      vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]])
      vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]])
      vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]])
    end,
    keys = {
      { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "ToggleTerm float" },
      { "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "ToggleTerm horizontal" }
    }
  }
}
