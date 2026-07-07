-- Better escape let's exist Insert mode pressing JK JJ KJ KK really quickly
vim.pack.add({ "https://github.com/max397574/better-escape.nvim" })

require("better_escape").setup()

-- Render Markdow helps visualizing markdow files
vim.pack.add({ "https://github.com/MeanderingProgrammer/render-markdown.nvim" })

vim.filetype.add({
	extension = {
		mdx = "markdown",
	},
})

require("render-markdown").setup({
	file_types = { "markdown", "md" },
})

-- Sometimes we need a bit of a Zen moment
vim.pack.add({ "https://github.com/folke/zen-mode.nvim" })

vim.keymap.set("n", "<leader>z", function()
	require("zen-mode").toggle()
end, { desc = "Zen Mode" })
