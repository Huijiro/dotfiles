return {
  {

    "mfussenegger/nvim-lint",
    dependencies = {
      "rshkarin/mason-nvim-lint",
      "williamboman/mason.nvim",
    },
    config = function()
      vim.api.nvim_create_autocmd("BufWritePost", {
        callback = function()
          require("lint").try_lint()
        end,
      })

      require("lint").linters_by_ft = {
        go = { "golangcilint" },
        javascript = { "eslint" },
        typescript = { "eslint" },
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
