return {
  'saghen/blink.cmp',
  event = "InsertEnter",
  dependencies = {
    {
      "supermaven-inc/supermaven-nvim",
      opts = {
        disable_inline_completion = true, -- disables inline completion for use with cmp
        disable_keymaps = true            -- disables built in keymaps for more manual control
      }
    },
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
    'Kaiser-Yang/blink-cmp-avante',
    "huijiro/blink-cmp-supermaven",
  },
  opts = {
    snippets = { preset = "luasnip" },
    sources = {
      default = { "avante", "lsp", 'path', "supermaven", "snippets", 'buffer' },
      providers = {
        lsp = {
          score_offset = 10,
          module = "blink.cmp.sources.lsp",
        },
        supermaven = {
          name = 'supermaven',
          module = "blink-cmp-supermaven",
          async = true
        },
        avante = {
          score_offset = 100,
          module = 'blink-cmp-avante',
          name = 'Avante',
          opts = {
          }
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
