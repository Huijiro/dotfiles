return {
  'stevearc/conform.nvim',
  lazy = false,
  config = function()
    local comform = require('conform')
    comform.setup({
      formatters_by_ft = {
        javascript = { "prettier" },
        jsonc = { "prettier" },
        json = { "prettier" },
        typescriptreact = { "prettier" },
        htmlangular = { "prettier" },
        typescript = { "prettier" },
        markdown = { "prettier" },
        cpp = { "clang-format" },
        python = { "black" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    })
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
