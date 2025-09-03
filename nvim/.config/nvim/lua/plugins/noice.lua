return {
  'folke/noice.nvim',
  event = "VeryLazy",
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    {
      "rcarriga/nvim-notify",
      lazy = true,
      opts = {
        timeout = 3000,
        max_height = function()
          return math.floor(vim.o.lines * 0.75)
        end,
        max_width = function()
          return math.floor(vim.o.columns * 0.75)
        end,
        on_open = function(win)
          vim.api.nvim_win_set_config(win, { zindex = 100 })
        end,
        background_colour = "#000000",
        top_down = false,
      },
    }
  },
  config = function()
    require('noice').setup({

      filter = {
        event = "msg_show",
        any = {
          { find = "Starting Supermaven" },
          { find = "Supermaven Free Tier" }
        }
      },
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true,         -- use a classic bottom cmdline for search
        command_palette = true,       -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
      },
    })
  end,
  keys = {
    { '<leader>fn', function()
        local noice = require("noice")
        local messages = {}
        
        -- Get noice message history using the correct API
        local history = require("noice.message.manager").get(nil, { history = true })
        
        for _, message in ipairs(history) do
          local content = message:content()
          if content and content ~= "" then
            table.insert(messages, {
              text = content,
              message = message
            })
          end
        end
        
        if #messages == 0 then
          vim.notify("No notifications found", vim.log.levels.INFO)
          return
        end
        
        require('mini.pick').start({
          source = {
            items = messages,
            name = "Notifications",
            choose = function(item)
              if item and item.text then
                -- Show full message in a split
                vim.cmd('split')
                local buf = vim.api.nvim_create_buf(false, true)
                vim.api.nvim_win_set_buf(0, buf)
                vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(item.text, '\n'))
                vim.bo[buf].filetype = 'text'
                vim.bo[buf].modifiable = false
              end
            end
          }
        })
      end, desc = "Notifications" },
    { "<S-Enter>",  function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c",                     desc = "Redirect Cmdline" },
    { '<leader>n',  '<cmd>:Noice dismiss<cr>',                                     desc = "Dismiss Noitifications" }
  }
}
