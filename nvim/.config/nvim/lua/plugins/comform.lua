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
        html = { "prettier" },
        typescript = { "prettier" },
        markdown = { "prettier" },
        cpp = { "clang-format" },
        python = { "black" },
      },
      format_on_save = {
        timeout_ms = 15000,
        lsp_format = "fallback",
      },
    })
  end,
  keys = {
    {
      "<leader>i",
      function()
        require("conform").format({
          async = true,
        })
      end,
      desc = "Format buffer",
    }
  }
}
