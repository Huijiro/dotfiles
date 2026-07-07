-- This file is my overall custom setup for basic neovim options.

-- Setup space as leader
vim.g.mapleader = " "

-- Enable fast module loading
vim.loader.enable()

-- Set highlight on search
vim.o.hlsearch = false

-- Line numbers
vim.wo.number = true
vim.opt.nu = true
vim.opt.relativenumber = true

-- Scrolloff
vim.opt.scrolloff = 8

-- 2 space indent by default
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Mouse mode
vim.o.mouse = "a"

-- Clipboard (Setup to sync with OS)
vim.o.clipboard = "unnamedplus"

-- Enable break indent
vim.o.breakindent = true

-- Undo
vim.opt.swapfile = false
vim.opt.backup = false
vim.o.undofile = true

-- Case-insensitive search by default
vim.o.ignorecase = true
vim.o.smartcase = true

-- Update time
vim.o.updatetime = 50
vim.o.timeoutlen = 300

-- THICC CURSOR
vim.opt.guicursor = ""

-- Wrap config
vim.opt.wrap = false
Config.new_autocmd("FileType", { "markdown", "mdx" }, function()
	vim.opt_local.wrap = true
	vim.opt_local.linebreak = true
end, "Enable wrap and linebreak on Markdow")

-- CMDLine
vim.opt.cmdheight = 0

-- Conceal level (Helps MD files)
vim.opt.conceallevel = 2

-- Built-in completion
vim.o.complete = ".,w,b,kspell" -- Use less sources
vim.o.completeopt = "menuone,noselect,fuzzy,nosort" -- Use custom behavior
vim.o.completetimeout = 100 -- Limit sources delay

-- Neovim has built-in support for showing diagnostic messages. This configures
-- a more conservative display while still being useful.
-- See `:h vim.diagnostic` and `:h vim.diagnostic.config()`.
local diagnostic_opts = {
	-- Show signs on top of any other sign, but only for warnings and errors
	signs = { priority = 9999, severity = { min = "WARN", max = "ERROR" } },

	-- Show all diagnostics as underline (for their messages type `<Leader>ld`)
	underline = { severity = { min = "HINT", max = "ERROR" } },

	-- Show more details immediately for errors on the current line
	virtual_lines = false,
	virtual_text = {
		current_line = true,
		severity = { min = "ERROR", max = "ERROR" },
	},

	-- Don't update diagnostics when typing
	update_in_insert = false,
}

-- Use `later()` to avoid sourcing `vim.diagnostic` on startup
Config.later(function()
	vim.diagnostic.config(diagnostic_opts)
end)
