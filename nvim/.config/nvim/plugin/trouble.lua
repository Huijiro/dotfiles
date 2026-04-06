vim.pack.add({ 'https://github.com/folke/trouble.nvim' })

require('trouble').setup({
  focus = true,
  keys = {
    ['<cr>'] = 'jump_close',
  },
  win = {
    type = 'float',
    relative = 'editor',
    size = { width = 0.8, height = 0.25 },
    position = { 0, 0.5 },
    border = 'rounded',
    title = ' Trouble ',
    title_pos = 'center',
    zindex = 50,
  },
})

vim.keymap.set('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', { desc = "Diagnostics (Trouble)" })
vim.keymap.set('n', '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
  { desc = "Buffer Diagnostics (Trouble)" })
vim.keymap.set('n', '<leader>cs', '<cmd>Trouble symbols toggle focus=false<cr>', { desc = "Symbols (Trouble)" })
vim.keymap.set('n', '<leader>cl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
  { desc = "LSP Definitions / references / ... (Trouble)" })
vim.keymap.set('n', '<leader>xL', '<cmd>Trouble loclist toggle<cr>', { desc = "Location List (Trouble)" })
vim.keymap.set('n', '<leader>xQ', '<cmd>Trouble qflist toggle<cr>', { desc = "Quickfix List (Trouble)" })
