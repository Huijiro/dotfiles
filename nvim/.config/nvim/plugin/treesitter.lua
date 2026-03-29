vim.pack.add({ 'https://github.com/nvim-treesitter/nvim-treesitter' })

-- Install parsers (no-op if already installed)
require('nvim-treesitter').install { 'lua', 'vim', 'typescript', 'json', 'vimdoc', 'markdown' }

-- Enable treesitter highlighting for all filetypes with a parser
vim.api.nvim_create_autocmd('FileType', {
  callback = function(ev)
    -- Skip commit messages
    if vim.fn.bufname():match('COMMIT_EDITMSG') then return end
    -- Enable treesitter highlighting if a parser exists
    if pcall(vim.treesitter.start, ev.buf) then
      -- Parser exists, highlighting enabled
    end
  end,
})
