return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  init = function()
    require("obsidian").setup({
      workspaces = {
        {
          name = "Agentuity",
          path = "~/Documents/Work/Agentuity Vault/",
        },
      },
    })
  end,
}
