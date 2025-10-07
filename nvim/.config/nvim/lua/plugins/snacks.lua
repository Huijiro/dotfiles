return {
  "folke/snacks.nvim",
  lazy = false,
  priority = 1000,
  --- @type snacks.Config
  opts = {
    notifier = { enabled = true },
    bigfile = { enabled = true },
    input = { enabled = true },
    image = { enabled = true },
    gitbrowse = { enabled = true }
  },
  init = function()
    -- Setup some globals for debugging (lazy-loaded)
    _G.dd = function(...)
      Snacks.debug.inspect(...)
    end
    _G.bt = function()
      Snacks.debug.backtrace()
    end
    -- Override print to use snacks for `:=` command
    if vim.fn.has("nvim-0.11") == 1 then
      vim._print = function(_, ...)
        dd(...)
      end
    else
      vim.print = _G.dd
    end

    -- Override vim.ui.input to use snacks input
    vim.ui.input = function(opts, on_confirm)
      return Snacks.input(opts, on_confirm)
    end

    ---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
    local progress = vim.defaulttable()
    vim.api.nvim_create_autocmd("LspProgress", {
      ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
      callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        local value = ev.data.params
            .value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
        if not client or type(value) ~= "table" then
          return
        end
        local p = progress[client.id]

        for i = 1, #p + 1 do
          if i == #p + 1 or p[i].token == ev.data.params.token then
            p[i] = {
              token = ev.data.params.token,
              msg = ("[%3d%%] %s%s"):format(
                value.kind == "end" and 100 or value.percentage or 100,
                value.title or "",
                value.message and (" **%s**"):format(value.message) or ""
              ),
              done = value.kind == "end",
            }
            break
          end
        end

        local msg = {} ---@type string[]
        progress[client.id] = vim.tbl_filter(function(v)
          return table.insert(msg, v.msg) or not v.done
        end, p)

        local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
        vim.notify(table.concat(msg, "\n"), "info", {
          id = "lsp_progress",
          title = client.name,
          opts = function(notif)
            notif.icon = #progress[client.id] == 0 and " "
                or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
          end,
        })
      end,
    })
  end,
  keys = {
    {
      ':',
      function()
        vim.ui.input({ prompt = ':', completion = 'cmdline' }, function(input)
          if input then
            vim.cmd(input)
          end
        end)
      end,
      desc = "Command line",
      mode = { 'n', 'v' }
    },
    {
      'gi',
      function() require('snacks').picker.lsp_implementations() end,
      desc = "LSP Implementation"
    },
    {
      'gd',
      function() require('snacks').picker.lsp_definitions() end,
      desc = "LSP Declaration"
    },
    {
      'gD',
      function() require('snacks').picker.lsp_declarations() end,
      desc = "LSP Type Declaration"
    },
    {
      '<leader>c',
      function() vim.lsp.buf.code_action() end,
      desc = "Code Action",
      mode = { 'n', 'v' }
    },
    {
      'gr',
      function() require('snacks').picker.lsp_references() end,
      desc = "LSP References"
    },
    {
      "<leader>ff",
      function() require('snacks').picker.files() end,
      desc = "Find files"
    },
    {
      "<leader>fg",
      function()
        return require('snacks').picker.grep()
      end,
      desc = "Find grep"
    },
    {
      "<leader>fb",
      function() require('snacks').picker.buffers() end,
      desc = "Find buffers"
    },
    {
      "<leader>G",
      function()
        require('snacks').gitbrowse.open({
          what = "repo"
        })
      end,
      desc = "Open repo"
    }
  }
}
