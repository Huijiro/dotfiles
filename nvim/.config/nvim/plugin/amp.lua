vim.pack.add({ { src = 'https://github.com/sourcegraph/amp.nvim', version = 'main' } })

require('amp').setup({ auto_start = true, log_level = "info" })
