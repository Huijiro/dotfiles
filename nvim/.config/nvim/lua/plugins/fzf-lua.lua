return {
  "ibhagwan/fzf-lua",
  dependencies = { "echasnovski/mini.icons" },
  opts = {},
  keys = {
    { "<leader>ff",  function() require("fzf-lua").files() end,            desc = "Find files" },
    { "<leader>fg",  function() require("fzf-lua").grep() end,             desc = "Find grep" },
    { "<leader>fb",  function() require("fzf-lua").buffers() end,          desc = "Find buffers" },
    { "<leader>fB",  function() require("fzf-lua").git_branches() end,     desc = "Find branches" },
    { "<leader>fs",  function() require("fzf-lua").git_status() end,       desc = "Git status" },
    { "<leader>fS",  function() require("fzf-lua").git_stash() end,        desc = "Git stash" },
    { "<leader>fc",  function() require("fzf-lua").git_commits() end,      desc = "Git commits" },
    { "<leader>fpt", function() require("fzf-lua").tmux_buffers() end,     desc = "Tmux Paste Buffers" },

    { "<C-S-c>",     function() require("fzf-lua").lsp_code_actions() end, desc = "Code actions" },
  }
}
