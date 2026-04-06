-- Load noice shortly after startup
vim.schedule(function()
  vim.pack.add({
    'https://github.com/MunifTanjim/nui.nvim',
    'https://github.com/folke/noice.nvim',
  })

  require('noice').setup({
    presets = {
      command_palette = true,
    },
    views = {
      split = {
        backend = 'popup',
        relative = 'editor',
        enter = true,
        close = {
          events = { 'BufLeave' },
          keys = { 'q' },
        },
        border = {
          style = 'rounded',
        },
        position = '50%',
        size = {
          width = '80%',
          height = '60%',
        },
        win_options = {
          winhighlight = { Normal = 'NoicePopup', FloatBorder = 'NoicePopupBorder' },
          winbar = '',
          foldenable = false,
          wrap = true,
        },
      },
    },
  })
end)
