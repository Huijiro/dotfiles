return {
  {
    "williamboman/mason.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "ts_ls", "clangd" },
        automatic_enable = true
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities())

      vim.keymap.set('n', 'J', vim.diagnostic.open_float)

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          local builtin = require('fzf-lua');

          local opts = { buffer = ev.buf }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'gs', builtin.lsp_document_symbols, opts)
          vim.keymap.set('n', 'gws', builtin.lsp_workspace_symbols, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gi', builtin.lsp_implementations, opts)
          vim.keymap.set('n', 'gtd', builtin.lsp_typedefs, opts)
          vim.keymap.set('n', 'R', vim.lsp.buf.rename, opts)
          vim.keymap.set({ 'n', 'v' }, 'C', vim.lsp.buf.code_action, { desc = "Code Action", buffer = ev.buf })
          vim.keymap.set('n', 'gr', builtin.lsp_references, opts)
          vim.keymap.set('n', ']g', vim.diagnostic.get_next, { desc = "Next Diagnostic" })
          vim.keymap.set('n', '[g', vim.diagnostic.get_prev, { desc = "Prev Diagnostic" })
        end,
      })
    end
  } }
