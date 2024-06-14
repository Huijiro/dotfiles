return {
  'echasnovski/mini.nvim',
  version = false,
  config = function()
    require('mini.pairs').setup()
    require('mini.ai').setup { n_lines = 500 }
    require('mini.surround').setup()
  end,
  keys = {
  }
}
