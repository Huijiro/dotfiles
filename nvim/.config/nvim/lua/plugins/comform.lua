return {
  'stevearc/conform.nvim',
  config = function()
    local comform = require('conform')
    comform.setup({
      formatters = {
        lua = { "stylua" },
        go = { "goimports", "gofmt" },
        javascript = { "eslint" },
        typescript = { "eslint" },
        markdown = { { "prettier" } },
      },
      format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_fallback = true,
      },
    })

    comform.formatters_by_ft.javascript = {
      "prettier"
    }

    comform.formatters_by_ft.typescript = {
      "prettier"
    }

    comform.formatters_by_ft.markdown = {
      "prettier"
    }

    comform.formatters_by_ft.cpp = {
      "clang-format",
    }
  end,
  keys = {
    {
      "<leader>i",
      function()
        require("conform").format()
      end,
      desc = "Format buffer",
    }
  }
}
