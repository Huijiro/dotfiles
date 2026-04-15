-- Load obsidian only for markdown files
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  once = true,
  callback = function()
    vim.pack.add({
      'https://github.com/nvim-lua/plenary.nvim',
      'https://github.com/epwalsh/obsidian.nvim',
    })

    require("obsidian").setup({
      ui = { enable = false },
      workspaces = {
        {
          name = "Agentuity",
          path = "~/Documents/Work/Agentuity Vault/",
        },
      },
    })
  end
})
