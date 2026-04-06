vim.pack.add{
  { src = 'https://github.com/neovim/nvim-lspconfig' },
}

vim.lsp.enable('biome')
vim.lsp.enable('clangd')
vim.lsp.enable('copilot')
vim.lsp.enable('cssls')
vim.lsp.enable('gopls')
vim.lsp.enable('html')
vim.lsp.enable('jsonls')
vim.lsp.enable('lua_ls')
vim.lsp.enable('pyright')
vim.lsp.enable('svelte')
vim.lsp.enable('tailwindcss')
vim.lsp.enable('ts_ls')

