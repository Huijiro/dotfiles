-- Auto-enable all LSP servers found in the lsp/ directory
for _, file in ipairs(vim.fn.glob(vim.fn.stdpath("config") .. "/lsp/*.lua", false, true)) do
  vim.lsp.enable(vim.fn.fnamemodify(file, ":t:r"))
end

vim.keymap.set('n', 'K', vim.lsp.buf.hover)
vim.keymap.set('n', 'J', vim.diagnostic.open_float)
vim.keymap.set('n', 'R', vim.lsp.buf.rename)
vim.keymap.set('n', ']g', vim.diagnostic.get_next, { desc = "Next Diagnostic" })
vim.keymap.set('n', '[g', vim.diagnostic.get_prev, { desc = "Prev Diagnostic" })
