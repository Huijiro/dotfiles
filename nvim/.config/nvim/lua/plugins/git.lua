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
      {
        "sindrets/diffview.nvim",
        config = function()
          require('diffview').setup({
            view = {
              file_panel = {
                listing_styles = "list"
              }
            }
          })
        end
      },
      "nvim-lua/plenary.nvim", -- required
    },
    config = true,
    keys = {
      { "<leader>g", function() require('neogit').open({ kind = "split" }) end, desc = "Open Neogit" },
    }
  }
}
