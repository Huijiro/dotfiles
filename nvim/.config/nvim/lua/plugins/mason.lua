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
        ensure_installed = { "lua_ls", "ts_ls", "clangd", "biome" },
        automatic_enable = true
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities())
      
      local lspconfig = require('lspconfig')
      local util = require('lspconfig.util')
      
      -- Configure biome LSP to only attach if biome.json exists
      lspconfig.biome.setup({
        capabilities = capabilities,
        root_dir = util.root_pattern("biome.json", "biome.jsonc"),
        single_file_support = false,
      })

      -- Configure diagnostics to show source
      vim.diagnostic.config({
        float = {
          source = true,  -- Show diagnostic source in float
        },
        virtual_text = {
          source = true,  -- Show diagnostic source in virtual text
        },
      })

      vim.keymap.set('n', 'J', vim.diagnostic.open_float)

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          local MiniExtra = require('mini.extra')

          local opts = { buffer = ev.buf }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'gs', function() MiniExtra.pickers.lsp({ scope = 'document_symbol' }) end, opts)
          vim.keymap.set('n', 'gws', function() MiniExtra.pickers.lsp({ scope = 'workspace_symbol' }) end, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gi', function() MiniExtra.pickers.lsp({ scope = 'implementation' }) end, opts)
          vim.keymap.set('n', 'gtd', function() MiniExtra.pickers.lsp({ scope = 'type_definition' }) end, opts)
          vim.keymap.set('n', 'R', vim.lsp.buf.rename, opts)
          vim.keymap.set({ 'n', 'v' }, 'C', vim.lsp.buf.code_action, { desc = "Code Action", buffer = ev.buf })
          vim.keymap.set('n', 'gr', function() MiniExtra.pickers.lsp({ scope = 'references' }) end, opts)
          vim.keymap.set('n', ']g', vim.diagnostic.get_next, { desc = "Next Diagnostic" })
          vim.keymap.set('n', '[g', vim.diagnostic.get_prev, { desc = "Prev Diagnostic" })
        end,
      })
    end
  } }
