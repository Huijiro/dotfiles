return {
  'stevearc/conform.nvim',
  lazy = false,
  config = function()
    local comform = require('conform')
    comform.setup({
      formatters_by_ft = {
        javascript = { "biome", "prettier" },
        jsonc = { "prettier" },
        json = { "biome", "prettier" },
        typescriptreact = { "biome", "prettier" },
        htmlangular = { "prettier" },
        html = { "prettier" },
        typescript = { "biome", "prettier" },
        markdown = { "prettier" },
        cpp = { "clang-format" },
        python = { "black" },
        rust = { lsp_format = "fallback" },
      },
      formatters = {
        biome = {
          args = { "check", "--write", "--unsafe", "--stdin-file-path", "$FILENAME" },
          condition = function(_, ctx)
            local root = vim.fs.find({ "biome.json", "biome.jsonc" }, {
              upward = true,
              path = ctx.dirname
            })[1]
            return root ~= nil
          end,
        },
        prettier = {
          condition = function(_, ctx)
            local root = vim.fs.find({
              ".prettierrc",
              ".prettierrc.json",
              ".prettierrc.yaml",
              ".prettierrc.yml",
              ".prettierrc.js",
              "prettier.config.js",
            }, {
              upward = true,
              path = ctx.dirname
            })[1]
            return root ~= nil
          end,
        },
      },
      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return {
          timeout_ms = 500,
          lsp_format = "fallback",
          notify_on_error = true,
        }
      end,
      notify_on_error = true,
    })



    vim.api.nvim_create_user_command("FormatDisable", function(args)
      if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
        vim.notify("Formatting disabled for buffer.")
      else
        vim.g.disable_autoformat = true
        vim.notify("Formatting disabled.")
      end
    end, {
      desc = "Disable autoformat-on-save",
      bang = true,
    })
    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
      vim.notify("Formatting enabled.")
    end, {
      desc = "Re-enable autoformat-on-save",
    })
  end,
  keys = {
    {
      "<leader>i",
      function()
        local conform = require("conform")
        local bufnr = vim.api.nvim_get_current_buf()
        local filetype = vim.bo[bufnr].filetype

        -- Get available formatters for this filetype
        local formatters = conform.list_formatters(bufnr)
        if #formatters == 0 then
          vim.notify("No formatters available for " .. filetype, vim.log.levels.WARN)
          return
        end

        -- Format and notify
        conform.format({
          bufnr = bufnr,
          async = true,
        }, function(err)
          if err then
            vim.notify("Format failed: " .. err, vim.log.levels.ERROR)
          else
            local used_formatters = {}
            for _, formatter in ipairs(formatters) do
              if formatter.available then
                table.insert(used_formatters, formatter.name)
              end
            end
            if #used_formatters > 0 then
              vim.notify("Formatted with: " .. table.concat(used_formatters, ", "), vim.log.levels.INFO)
            end
          end
        end)
      end,
      desc = "Format buffer",
    }
  }
}
