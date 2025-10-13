-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- Set scrolloff
vim.opt.scrolloff = 8

-- Make 2 space indents
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.opt.swapfile = false
vim.opt.backup = false
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 50
vim.o.timeoutlen = 300

-- Keep cursor fat
vim.opt.guicursor = ""

-- Disable line wrap
vim.opt.wrap = false

-- Fix git diff
vim.o.diffopt = "internal,filler,closeoff,linematch:40"

-- Set autoread and trigger on focus/buffer enter
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  callback = function()
    if vim.fn.mode() ~= 'c' then
      vim.cmd('checktime')
    end
  end,
})

-- Add support for .env, .env.local, .env.example etc.
vim.filetype.add({
  pattern = {
    [".*%.env.*"] = "sh", -- or "dotenv" if you have a plugin for it
  },
})
