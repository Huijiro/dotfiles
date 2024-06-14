return {
  'stevearc/dressing.nvim',
  lazy = false,
  depencencies = { 'https://github.com/MunifTanjim/nui.nvim' },
  config = function()
    require("dressing").setup({
      select = {
        get_config = function(opts)
          if opts.kind == 'codeaction' then
            return {
              backend = 'nui',
            }
          end
        end
      }
    })
  end
}
