vim.pack.add({
	"https://github.com/f-person/git-blame.nvim",
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/NeogitOrg/neogit",
})

require("gitsigns").setup({
	signs = {
		add = { text = "▎" },
		change = { text = "▎" },
		delete = { text = "" },
		topdelete = { text = "" },
		changedelete = { text = "▎" },
		untracked = { text = "▎" },
	},
})

require("neogit").setup({
	integrations = {
		diffview = false,
		mini_pick = true,
	},
})

vim.keymap.set("n", "<leader>g", function()
	require("neogit").open({ kind = "split" })
end, { desc = "Open Neogit" })

vim.pack.add({
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-telescope/telescope.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/pwntester/octo.nvim",
})

require("octo").setup({
	-- or "fzf-lua" or "snacks" or "default"
	picker = "default",
	-- bare Octo command opens picker of commands
	enable_builtin = true,
})

local octo_commands = require("octo.commands").commands

vim.keymap.set("n", "<leader>oi", function()
	octo_commands.issue.list()
end, { desc = "List GitHub Issues" })
vim.keymap.set("n", "<leader>op", function()
	octo_commands.pr.list()
end, { desc = "List GitHub PullRequests" })
vim.keymap.set("n", "<leader>od", function()
	octo_commands.discussion.list()
end, { desc = "List GitHub Discussions" })
vim.keymap.set("n", "<leader>on", function()
	octo_commands.notification.list()
end, { desc = "List GitHub Notifications" })
vim.keymap.set("n", "<leader>os", function()
	require("octo.utils").create_base_search_command({ include_current_repo = true })
end, { desc = "Search GitHub" })
