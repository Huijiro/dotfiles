vim.pack.add({ 'https://github.com/nvim-treesitter/nvim-treesitter' })

-- Install parsers (no-op if already installed)
require('nvim-treesitter').install { 'lua', 'bash', 'regex', 'vim', 'typescript', 'json', 'vimdoc', 'markdown', 'css', 'javascript', 'latex', 'norg', 'scss', 'svelte', 'tsx', 'typst', 'vue' }

-- Enable treesitter highlighting for all filetypes with a parser
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    local lang = vim.treesitter.language.get_lang(args.match)
    if lang and vim.treesitter.language.add(lang) then
      vim.treesitter.start()
    end
  end,
})
