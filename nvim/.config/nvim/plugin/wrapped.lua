-- wrapped.nvim — only loaded via :NvimWrapped command
vim.api.nvim_create_user_command('NvimWrapped', function()
  vim.pack.add({
    'https://github.com/nvzone/volt',
    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/aikhe/wrapped.nvim',
  })
  require('wrapped').setup()
  vim.cmd('NvimWrapped')
end, {})
