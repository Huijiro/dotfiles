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
    { "<leader>e", function() require('mini.files').open() end, desc = "Open file" },
  }
}
