return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = { use_diagnostic_signs = true },
  keys = {
    {"<leader>xx", ":TroubleToggle<CR>", desc = "Toggle Trouble"},
    {"<leader>xw", ":TroubleToggle workspace_diagnostics<CR>", desc = "Toggle Trouble: LSP Diagnostics (Workspace)"},
    {"<leader>xd", ":TroubleToggle document_diagnostics<CR>", desc = "Toggle Trouble: LSP Diagnostics (Document)"},
    {"<leader>xl", ":TroubleToggle loclist<CR>", desc = "Toggle Trouble: Location List"},
    {"<leader>xq", ":TroubleToggle quickfix<CR>", desc = "Toggle Trouble: Quickfix"},
  }
}
