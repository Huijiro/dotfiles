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
        ensure_installed = { "lua_ls", "tsserver", "clangd" }
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      require("mason-lspconfig").setup_handlers {
        -- The first entry (without a key) will be the default handler
        -- and will be called for each installed server that doesn't have
        -- a dedicated handler.
        function(server_name) -- default handler (optional)
          local server = require("lspconfig")[server_name]
          server.setup {
            capabilities = vim.tbl_deep_extend('force', capabilities, server.capabilities or {})
          }
        end,
        ["svelte"] = function()
          local svelte = require("lspconfig").svelte;
          svelte.setup {
          }
        end,
        ["lua_ls"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.lua_ls.setup {
            capabilities = vim.tbl_deep_extend('force', capabilities, lspconfig.lua_ls.capabilities or {}),
            settings = {
              Lua = {
                runtime = { version = 'LuaJIT' },
                workspace = {
                  library = {
                    vim.env.VIMRUNTIME,
                  }
                }
              }
            }
          }
        end,
      }

      vim.keymap.set('n', 'J', vim.diagnostic.open_float)

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          local builtin = require('telescope.builtin');

          local opts = { buffer = ev.buf }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gd', builtin.lsp_definitions, opts)
          vim.keymap.set('n', 'gs', builtin.lsp_document_symbols, opts)
          vim.keymap.set('n', 'gws', builtin.lsp_workspace_symbols, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gi', builtin.lsp_implementations, opts)
          vim.keymap.set('n', 'gtd', builtin.lsp_type_definitions, opts)
          vim.keymap.set('n', 'R', vim.lsp.buf.rename, opts)
          vim.keymap.set({ 'n', 'v' }, 'C', vim.lsp.buf.code_action, { desc = "Code Action", buffer = ev.buf })
          vim.keymap.set('n', 'gr', builtin.lsp_references, opts)
          vim.keymap.set('n', ']g', vim.diagnostic.goto_next, { desc = "Next Diagnostic" })
          vim.keymap.set('n', '[g', vim.diagnostic.goto_prev, { desc = "Prev Diagnostic" })
        end,
      })
    end
  } }
