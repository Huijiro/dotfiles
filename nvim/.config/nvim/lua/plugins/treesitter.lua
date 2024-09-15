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
        ensure_installed = { "lua", "vim", "typescript", "json", "vimdoc", "markdown" },
        sync_install = false,
        autotag = {
          enable = true
        },
      }
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    opts = {
      enable_close = true,
      enable_rename = true,
      enable_close_on_slash = false
    }
  },
}
