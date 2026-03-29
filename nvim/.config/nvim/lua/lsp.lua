-- Auto-enable all LSP servers found in the lsp/ directory
-- Exception: ts_ls is disabled by default (use tsgo as primary TypeScript LSP)
for _, file in ipairs(vim.fn.glob(vim.fn.stdpath("config") .. "/lsp/*.lua", false, true)) do
  local name = vim.fn.fnamemodify(file, ":t:r")
  if name ~= 'ts_ls' then
    vim.lsp.enable(name)
  end
end

vim.keymap.set('n', 'K', vim.lsp.buf.hover)
vim.keymap.set('n', 'J', vim.diagnostic.open_float)
vim.keymap.set('n', 'R', vim.lsp.buf.rename)
vim.keymap.set('n', ']g', vim.diagnostic.get_next, { desc = "Next Diagnostic" })
vim.keymap.set('n', '[g', vim.diagnostic.get_prev, { desc = "Prev Diagnostic" })

-- TypeScript LSP switcher (ts_ls <-> tsgo)
require('typescript-switcher')
