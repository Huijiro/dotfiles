-- Load better-escape on InsertEnter
vim.api.nvim_create_autocmd('InsertEnter', { once = true, callback = function()
  vim.pack.add({ 'https://github.com/max397574/better-escape.nvim' })
  require("better_escape").setup()
end })
