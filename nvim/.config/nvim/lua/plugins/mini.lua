return {
  {
    'nvim-mini/mini.nvim',
    version = false,
    init = function()
      require('mini.pairs').setup()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.statusline').setup()
      require('mini.surround').setup()
      require('mini.icons').setup()
      require('mini.files').setup({
        mappings = {
          synchronize = "w"
        }
      })
      require('mini.pick').setup({
        window = {
          config = function()
            local height = math.floor(0.8 * vim.o.lines)
            local width = math.floor(0.9 * vim.o.columns)
            return {
              anchor = 'NW',
              height = height,
              width = width,
              row = math.floor(0.5 * (vim.o.lines - height)),
              col = math.floor(0.5 * (vim.o.columns - width)),
            }
          end,
          prompt_caret = '❯ ',
          prompt_prefix = '',
        },
        options = {
          content_from_bottom = true,
          use_cache = true,
        },
        mappings = {
          scroll_down = '<C-f>',
          scroll_up = '<C-b>',
          toggle_preview = '<Tab>',
        }
      })
      vim.ui.select = MiniPick.ui_select
      local hipatterns = require('mini.hipatterns')

      -- Color words mapping
      local color_words = {
        red = '#ff0000',
        green = '#00ff00',
        blue = '#0000ff',
        yellow = '#ffff00',
        purple = '#800080',
        orange = '#ffa500',
        cyan = '#00ffff',
        magenta = '#ff00ff',
        lime = '#32cd32',
        pink = '#ffc0cb',
        brown = '#a52a2a',
        gray = '#808080',
        grey = '#808080'
      }

      local word_color_group = function(_, match)
        local hex = color_words[match:lower()]
        if hex == nil then return nil end
        return hipatterns.compute_hex_color_group(hex, 'bg')
      end

      -- Censor sensitive information
      local censor_extmark_opts = function(_, match, _)
        -- Don't censor if toggle is disabled
        if vim.g.mini_hipatterns_censor_disabled then
          return nil
        end
        local mask = string.rep('█', vim.fn.strchars(match))
        return {
          virt_text = { { mask, 'Comment' } },
          virt_text_pos = 'overlay',
          priority = 200,
          right_gravity = false,
        }
      end

      hipatterns.setup({
        highlighters = {
          fixme       = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
          hack        = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
          todo        = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
          note        = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },

          hex_color   = hipatterns.gen_highlighter.hex_color(),

          -- Highlight color word names with their actual colors
          color_names = {
            pattern = '%f[%w]()' .. table.concat(vim.tbl_keys(color_words), '|'):lower() .. '()%f[%W]',
            group = word_color_group
          },

          -- Censor all values in .env files
          env_values  = {
            pattern = function(buf_id)
              local filename = vim.api.nvim_buf_get_name(buf_id)
              if not (filename:match('%.env$') or filename:match('%.env%.') or filename:match('/%.env$')) then
                return nil
              end
              return '^[%w_]+[%s]*=[%s]*().-()$'
            end,
            group = '',
            extmark_opts = censor_extmark_opts,
          },
        },
      })

      -- Toggle function to show/hide censored content
      vim.api.nvim_create_user_command("ToggleCensor", function()
        if vim.g.mini_hipatterns_censor_disabled then
          vim.g.mini_hipatterns_censor_disabled = false
          vim.notify("Censoring enabled - sensitive values hidden", vim.log.levels.INFO)
        else
          vim.g.mini_hipatterns_censor_disabled = true
          vim.notify("Censoring disabled - sensitive values visible", vim.log.levels.WARN)
        end
        -- Refresh hipatterns for current buffer
        vim.cmd('edit')
      end, { desc = "Toggle censoring of sensitive information" })

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
          local languages = {
            "Rust",
            "Lua",
            "Javascript",
            "Typescript",
            "Java",
            "COBOL",
            "Fortran",
            "BASIC"
          }

          local content_creator = {
            "The Primeagen",
            "Theo",
            "The Cherno",
            "fireship",
            "low level",
            "acerola"
          }
          -- show random message from array of messages (jokes)
          local messages = {
            "programming is pain.",
            "now with extra features(bugs).",
            "i'm a programmer, not a artist.",
            "i'm not a programmer, i'm a artist.",
            "have you tried asking ai?",
            "you can't do that on a programming contest.",
            "[error] neovim stopped working! -jk",
            "uncaught typeerror: object is not a function",
            "we are " .. math.random(1, 30) .. " days away from ai stealing all our jobs.",
            "always code as if the guy who ends up maintaining your code will be a violent psychopath who knows where you live.",
            "don't delete coconut.png",
            "i forgot how to implement http2/3",
            "how do i reset my main branch again?",
            "sorry, commited to main.",
            "[object object]",
            "have you considered using a language that is more suited for this task? like " ..
            languages[math.random(1, #languages)] .. ".",
            "have you consider paying for a course?",
            "what would " .. content_creator[math.random(1, #content_creator)] .. " do?",
            "when are you studying assembly again?"
          }

          local random = math.random(1, #messages)

          return messages[random]
        end
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
      },
      {
        "<leader>tc",
        ":ToggleCensor<CR>",
        desc = "Toggle censoring"
      },
    }
  },
}
