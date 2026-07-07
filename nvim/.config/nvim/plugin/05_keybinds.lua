vim.keymap.set('n', 'Q', '<nop>')
vim.keymap.set('n', 'U', '<C-r>')
vim.keymap.set('n', 'H', '^')
vim.keymap.set('n', 'L', '$')
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 's', '<nop>')

-- File management keymaps
vim.keymap.set('n', '<leader>w', ':w<cr>', { desc = "Save" })
vim.keymap.set('n', '<leader>q', ':q<cr>', { desc = "Quit" })
vim.keymap.set('n', '<leader>Q', ':q!<cr>', { desc = "Force quit" })
vim.keymap.set('n', '<leader>r', ':e<cr>', { desc = "Reload file" })
vim.keymap.set('n', '<leader>R', ':e!<cr>', { desc = "Force Reload File" })


-- Prevent deletes from overwriting clipboard
vim.keymap.set({ "n", "v" }, "d", '"_d')
vim.keymap.set({ "n", "v" }, "D", '"_D')

-- Prevent changes from overwriting clipboard
vim.keymap.set({ "n", "v" }, "c", '"_c')
vim.keymap.set("n", "C", '"_C')

-- Prevent visual paste from overwriting clipboard
vim.keymap.set("x", "p", '"_dP')

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
