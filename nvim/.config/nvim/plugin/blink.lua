-- Lazy load blink.cmp on InsertEnter
vim.api.nvim_create_autocmd('InsertEnter', { once = true, callback = function()
  vim.pack.add({
    'https://github.com/L3MON4D3/LuaSnip',
    'https://github.com/saghen/blink.compat',
    'https://github.com/supermaven-inc/supermaven-nvim',
    'https://github.com/huijiro/blink-cmp-supermaven',
    'https://github.com/saghen/blink.cmp',
  })

  require('supermaven-nvim').setup({
    disable_inline_completion = true,
    disable_keymaps = true,
  })

  require('blink.compat').setup({
    enable_events = true,
  })

  require('blink.cmp').setup({
    snippets = { preset = "luasnip" },
    sources = {
      default = { "lsp", 'supermaven', 'path', "snippets", 'buffer' },
      providers = {
        lsp = {
          score_offset = 10,
          module = "blink.cmp.sources.lsp",
        },
        supermaven = {
          name = 'supermaven',
          module = 'blink-cmp-supermaven',
          async = true,
        }
      }
    },
    fuzzy = { implementation = "lua" },
    keymap = {
      ['<C-j>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<C-e>'] = { 'hide' },
      ['<C-y>'] = { 'select_and_accept' },

      ['<Up>'] = { 'select_prev', 'fallback' },
      ['<Down>'] = { 'select_next', 'fallback' },
      ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
      ['<C-n>'] = { 'select_next', 'fallback_to_mappings' },

      ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

      ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
    }
  })
end })
