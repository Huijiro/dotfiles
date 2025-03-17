return {
  'echasnovski/mini.nvim',
  config = function()
    require('mini.pairs').setup()
    require('mini.ai').setup { n_lines = 500 }
    require('mini.surround').setup()
    require('mini.icons').setup()
    require('mini.files').setup({
      mappings = {
        synchronize = "w"
      }
    })
  end,
  keys = {
    {
      "<leader>e",
      function()
        local files = require("mini.files")
        files.open(vim.api.nvim_buf_get_name(0))
        files.reveal_cwd()
      end,
      desc = "Open current working directory on file"
    },
    {
      "<leader>E",
      function()
        local files = require("mini.files")
        files.open()
      end,
      desc = "Open current working directory"
    }
  }
}
