return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter"
  },
  opts = {
    defaults = {
      pickers = {
        git_files = { recuse_submodules = false }
      }
    }
  },
  keys = {
    { "<leader>ff", function() require('telescope.builtin').find_files({ hidden = true }) end, desc = "Find files" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>",                                            desc = "Find grep" },
    { "<leader>fB", "<cmd>Telescope git_branches<cr>",                                         desc = "Find branches" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>",                                              desc = "Find buffers" },
    { "<leader>fs", "<cmd>Telescope git_status<cr>",                                           desc = "Git status" },
    { "<leader>fS", "<cmd>Telescope git_stash<cr>",                                            desc = "Git stash" },
    { "<leader>fc", "<cmd>Telescope git_commits<cr>",                                          desc = "Git commits" },
    {
      "<leader>fC",
      function()
        require('telescope.builtin').
            find_files {
              cwd = vim.fn.stdpath('config')
            }
      end,
      desc = "Find config files"
    }
  }
}
