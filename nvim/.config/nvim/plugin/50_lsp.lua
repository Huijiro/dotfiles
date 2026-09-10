vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
})

vim.lsp.enable("biome")
vim.lsp.enable("clangd")
vim.lsp.enable("cssls")
vim.lsp.enable("gopls")
vim.lsp.enable("html")
vim.lsp.enable("jsonls")
vim.lsp.enable("lua_ls")
vim.lsp.enable("pyright")
vim.lsp.enable("svelte")
vim.lsp.enable("tailwindcss")
local ts_filetypes = {
	"javascript",
	"javascriptreact",
	"typescript",
	"typescriptreact",
}

local function typescript_root(bufnr)
	return vim.fs.root(bufnr, {
		"tsconfig.json",
		"jsconfig.json",
		"package.json",
		".git",
	})
end

local function uses_tsgo(bufnr)
	local root = typescript_root(bufnr)
	if not root then
		return false
	end

	local dir = root
	while dir do
		local package_json = dir .. "/node_modules/typescript/package.json"
		local ok, package = pcall(function()
			return vim.json.decode(table.concat(vim.fn.readfile(package_json), "\n"))
		end)
		if ok and type(package) == "table" and type(package.version) == "string" then
			local major = tonumber(package.version:match("^(%d+)"))
			return major ~= nil and major >= 7
		end

		local parent = vim.fs.dirname(dir)
		dir = parent ~= dir and parent or nil
	end

	return false
end

vim.lsp.config("ts_ls", {
	root_dir = function(bufnr, on_dir)
		if not uses_tsgo(bufnr) then
			on_dir(typescript_root(bufnr))
		end
	end,
})

vim.lsp.config("tsgo", {
	cmd = { "pnpm", "exec", "tsc", "--lsp", "--stdio" },
	filetypes = ts_filetypes,
	root_dir = function(bufnr, on_dir)
		if uses_tsgo(bufnr) then
			on_dir(typescript_root(bufnr))
		end
	end,
})

vim.lsp.enable({ "ts_ls", "tsgo" })
vim.lsp.enable("sqls")
vim.lsp.enable("jdtls")
vim.lsp.enable("ols")
vim.lsp.enable("rust_analyzer")

vim.keymap.set("n", "K", vim.lsp.buf.hover)
vim.keymap.set("n", "J", vim.diagnostic.open_float)
vim.keymap.set("n", "R", vim.lsp.buf.rename)
vim.keymap.set("n", "]g", vim.diagnostic.get_next, { desc = "Next Diagnostic" })
vim.keymap.set("n", "[g", vim.diagnostic.get_prev, { desc = "Prev Diagnostic" })
vim.keymap.set({ "n", "v" }, "<leader>c", vim.lsp.buf.code_action, { desc = "Code Action" })
