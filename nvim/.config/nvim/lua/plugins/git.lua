return {
  { 'f-person/git-blame.nvim' },
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
    },
    config = function()
      require('gitsigns').setup()
    end
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require('neogit').setup({
        integrations = {
          diffview = false,
          mini_pick = true,
        },
      })
    end,
    keys = {
      { "<leader>g", function() require('neogit').open({ kind = "split" }) end, desc = "Open Neogit" },
    }
  }
}
