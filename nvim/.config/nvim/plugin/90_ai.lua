vim.pack.add({ "https://github.com/folke/sidekick.nvim" })

require("sidekick").setup({
	nes = {
		enabled = false,
	},
	cli = {
		win = {
			layout = "left",
		},
		mux = {
			backend = "tmux",
			enabled = true,
		},
	},
})

vim.keymap.set("n", "<leader>aa", function()
	require("sidekick.cli").toggle()
end, { desc = "Toggle Sidekick" })

vim.keymap.set("n", "<leader>as", function()
	require("sidekick.cli").select()
end, { desc = "Select CLI" })

vim.keymap.set("n", "<leader>ac", function()
	require("sidekick.cli").show({
		name = "cursor",
	})
end, { desc = "Select Cursor" })

vim.keymap.set({ "x", "n" }, "<leader>at", function()
	require("sidekick.cli").send({ msg = "{this}" })
end, { desc = "Send to CLI" })

vim.keymap.set("n", "<leader>af", function()
	require("sidekick.cli").send({ msg = "{file}" })
end, { desc = "Send File" })

vim.keymap.set("x", "<leader>av", function()
	require("sidekick.cli").send({ msg = "{selection}" })
end, { desc = "Send File" })

vim.keymap.set("n", "<leader>ap", function()
	require("sidekick.cli").prompt()
end, { desc = "Select Prompt" })
