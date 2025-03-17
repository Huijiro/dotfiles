return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ":TSUpdate",
    config = function()
      require('nvim-treesitter.configs').setup {
        highlight = {
          enable = true,
          disable = function()
            local buf_name = vim.fn.bufname()
            if buf_name:match('COMMIT_EDITMSG') then return true end
          end,
          additional_vim_regex_highlighting = false,
        },
        auto_install = true,
        ensure_installed = { "lua", "vim", "typescript", "json", "vimdoc", "markdown" },
        sync_install = false,
      }
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
    end
  },
  {
    "davidmh/mdx.nvim",
    config = true,
    dependencies = { "nvim-treesitter/nvim-treesitter" }
  }
}
