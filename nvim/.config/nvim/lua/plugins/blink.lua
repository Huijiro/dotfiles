return {
  'saghen/blink.cmp',
  event = "InsertEnter",
  dependencies = {
    {
      "L3MON4D3/LuaSnip",
      version = "v2.*",
    },
    {
      "saghen/blink.compat",
      opts = {
        enable_events = true
      }
    },
  },
  opts = {
    snippets = { preset = "luasnip" },
    sources = {
      default = { "lsp", 'path', "snippets", 'buffer' },
      providers = {
        lsp = {
          score_offset = 10,
          module = "blink.cmp.sources.lsp",
        },
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
  }
}
