-- render-markdown depends on treesitter and mini.nvim (both loaded eagerly)
vim.pack.add({ 'https://github.com/MeanderingProgrammer/render-markdown.nvim' })

vim.filetype.add({
  extension = {
    mdx = 'markdown',
  },
})

require('render-markdown').setup({
  file_types = { "markdown", "md" },
})
