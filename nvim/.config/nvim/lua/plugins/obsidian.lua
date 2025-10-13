return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "Agentuity",
        path = "~/Documents/Work/Agentuity Vault/",
      },
    },

  },
  keys = {
    { "<leader>o", "<cmd>Obsidian<cr>", desc = "Open Obsidian" },
  }
}
