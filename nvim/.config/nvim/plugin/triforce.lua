vim.pack.add({
  'https://github.com/nvzone/volt',
  'https://github.com/gisketch/triforce.nvim',
})

require('triforce').setup({
  keymap = {
    show_profile = nil,
  }
})

vim.keymap.set('n', '<leader>m', function()
  require('triforce').show_profile()
end, { desc = "Show achievements" })
