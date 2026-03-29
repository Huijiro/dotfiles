-- Load noice shortly after startup
vim.schedule(function()
  vim.pack.add({
    'https://github.com/MunifTanjim/nui.nvim',
    'https://github.com/folke/noice.nvim',
  })

  require('noice').setup({
    presets = {
      command_palette = true,
    }
  })
end)
