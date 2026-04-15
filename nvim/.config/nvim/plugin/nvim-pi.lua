vim.pack.add({ 'https://github.com/huijiro/nvim-pi' })

require("nvim-pi").setup({
  auto_export_socket = true,
  show_notifications = true,
  highlight_duration = 4000,
  sign_enabled = true,
})
