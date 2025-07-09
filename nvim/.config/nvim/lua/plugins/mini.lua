return {
  {

    'echasnovski/mini.nvim',
    config = function()
      require('mini.pairs').setup()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()
      require('mini.icons').setup()
      require('mini.files').setup({
        mappings = {
          synchronize = "w"
        }
      })
      require('mini.hipatterns').setup({
        highlighters = {
          fixme     = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
          hack      = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
          todo      = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
          note      = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },

          hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
        },
      })
    end,
    keys = {
      {
        "<leader>e",
        function()
          local files = require("mini.files")
          local buf = vim.api.nvim_buf_get_name(0)



          if buf:match("ministarter") then
            files.open()
          else
            files.open(vim.api.nvim_buf_get_name(0))
            files.reveal_cwd()
          end
        end,
        desc = "Open current working directory on file"
      },
      {
        "<leader>E",
        function()
          local files = require("mini.files")
          files.open()
        end,
        desc = "Open current working directory"
      }
    }
  },
  {
    "echasnovski/mini.starter",
    event = "VimEnter",
    config = function()
      require('mini.statusline').setup()
      local starter = require('mini.starter')
      starter.setup({
        autoopen = true,
        evaluate_single = true,
        header = ' ▄▄    ▄ ▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄ ▄▄   ▄▄ ▄▄▄ ▄▄   ▄▄ \
█  █  █ █       █       █  █ █  █   █  █▄█  █\
█   █▄█ █    ▄▄▄█   ▄   █  █▄█  █   █       █\
█       █   █▄▄▄█  █ █  █       █   █       █\
█  ▄    █    ▄▄▄█  █▄█  █       █   █       █\
█ █ █   █   █▄▄▄█       ██     ██   █ ██▄██ █\
█▄█  █▄▄█▄▄▄▄▄▄▄█▄▄▄▄▄▄▄█ █▄▄▄█ █▄▄▄█▄█   █▄█',
        items = {
          starter.sections.builtin_actions(),
          starter.sections.recent_files(9, true),
        },
        content_hooks = {
          starter.gen_hook.adding_bullet(),
          starter.gen_hook.indexing('all', { 'Builtin actions' }),
          starter.gen_hook.padding(3, 2),
          starter.gen_hook.aligning("center", "center")
        },
        footer = function()
          -- Show random message from array of messages (jokes)
          local messages = {
            "Programming is pain.",
            "Now with extra features(bugs).",
            "I'm a programmer, not a artist.",
            "I'm not a programmer, I'm a artist.",
            "Have you tried asking AI?",
            "You can't do that on a programming contest.",
            "[ERROR] Neovim stopped working! -jk",
            "Uncaught TypeError: object is not a function",
            "We are " .. math.random(1, 30) .. " days away from AI stealing all our jobs."
          }

          local random = math.random(1, #messages)

          return messages[random]
        end
      })
    end
  }
}
