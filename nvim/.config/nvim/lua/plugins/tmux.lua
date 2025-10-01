return {
  {
    "aserowy/tmux.nvim",

    config = function()
      local function tmux_navigate(direction)
        local vim_direction = ({ h = "h", j = "j", k = "k", l = "l" })[direction]
        local tmux_direction = ({ h = "L", j = "D", k = "U", l = "R" })[direction]

        local current_win = vim.fn.winnr()
        vim.cmd("wincmd " .. vim_direction)

        if current_win == vim.fn.winnr() and vim.env.TMUX then
          vim.fn.system("tmux select-pane -" .. tmux_direction)
        end
      end

      local modes = { "n", "i", "v", "x", "s" }
      local keybinds = {
        { "<c-h>", "h" },
        { "<c-j>", "j" },
        { "<c-k>", "k" },
        { "<c-l>", "l" },
      }
      for _, keybind in ipairs(keybinds) do
        vim.keymap.set(modes, keybind[1], function() tmux_navigate(keybind[2]) end, { silent = true })
      end

      return require("tmux").setup({
        copy_sync = {
          enable = false
        },
      })
    end
  }
}
