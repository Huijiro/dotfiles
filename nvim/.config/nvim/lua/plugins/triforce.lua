return {
  'gisketch/triforce.nvim',
  dependencies = { 'nvzone/volt' },
  opts = {
    keymap = {
      show_profile = nil,
    }
  },
  keys = {
    {
      '<leader>m',
      function() require('triforce').show_profile() end,
      desc = "Show achivements"
    },
  }
}
