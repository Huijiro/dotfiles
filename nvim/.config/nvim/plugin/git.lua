vim.pack.add({
  'https://github.com/f-person/git-blame.nvim',
  'https://github.com/lewis6991/gitsigns.nvim',
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/NeogitOrg/neogit',
})

require('gitsigns').setup({
  signs = {
    add = { text = "▎" },
    change = { text = "▎" },
    delete = { text = "" },
    topdelete = { text = "" },
    changedelete = { text = "▎" },
    untracked = { text = "▎" },
  },
})

require('neogit').setup({
  integrations = {
    diffview = false,
    mini_pick = true,
  },
})

vim.keymap.set('n', '<leader>g', function()
  require('neogit').open({ kind = "split" })
end, { desc = "Open Neogit" })
