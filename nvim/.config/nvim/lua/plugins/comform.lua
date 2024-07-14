return {
  'stevearc/conform.nvim',
  config = function()
    local comform = require('conform')
    comform.setup({
      formatters = {
        lua = { "stylua" },
        go = { "goimports", "gofmt" },
        javascript = { { "prettierd", "prettier" }, "eslint_d" },
        markdown = { { "prettier" } },
      },
      format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_fallback = true,
      },
    })

    comform.formatters_by_ft.markdown = {
      "prettier"
    }

    comform.formatters_by_ft.cpp = {
      "clang-format",
    }

    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*",
      callback = function(args)
        comform.format({ bufnr = args.buf })
      end,
    })
  end,
  keys = {
    {
      "<leader>i",
      function()
        vim.lsp.buf.format({
          async = true,
        })
      end,
      desc = "Format buffer",
    }
  }
}
