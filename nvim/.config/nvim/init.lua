-- Enable fast module loading (can speed up startup ~30%)
vim.loader.enable()

-- Set leader keys before anything else
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Core config
require("settings")
require("keymaps")
require("lsp")

-- Plugin hooks (must be defined before vim.pack.add() calls in plugin/ files)
vim.api.nvim_create_autocmd('PackChanged', { callback = function(ev)
  local name, kind = ev.data.spec.name, ev.data.kind
  if name == 'nvim-treesitter' and kind == 'update' then
    if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
    vim.cmd('TSUpdate')
  end
end })
