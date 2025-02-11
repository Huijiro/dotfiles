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
    "sindrets/diffview.nvim",
    keys = {
      { "<leader>D", function() require('diffview').open() end, desc = "Open diffview" },
    }
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "sindrets/diffview.nvim",
      "nvim-lua/plenary.nvim", -- required
    },
    config = true,
    keys = {
      { "<leader>g", function() require('neogit').open({ kind = "split" }) end, desc = "Open Neogit" },
    }
  }
}
