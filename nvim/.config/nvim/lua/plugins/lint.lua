return {
  {
    "mfussenegger/nvim-lint",
    dependencies = {
      "rshkarin/mason-nvim-lint",
      "williamboman/mason.nvim",
    },
    config = function()
      require("mason-nvim-lint").setup({
        automatic_installation = true,
      })

      vim.api.nvim_create_autocmd("BufWritePost", {
        callback = function()
          require("lint").try_lint()
        end,
      })

      vim.api.nvim_create_autocmd("BufReadPost", {
        callback = function()
          require("lint").try_lint()
        end,
      })


      local lint = require("lint")

      lint.linters_by_ft = {
        go = { "golangcilint" },
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
      }
    end,
    keys = {
      {
        "<leader>I",
        function()
          require("lint").try_lint()
        end,
        desc = "Lint buffer",
      }
    }
  },
}
