-- TypeScript LSP switcher between ts_ls and tsgo
-- Use :TsSwitch or <leader>ts to toggle

local M = {}

M.typescript_lsps = { 'ts_ls', 'tsgo' }
M.typescript_lsp_filetypes = {
  javascript = true,
  ['javascriptreact'] = true,
  ['javascript.jsx'] = true,
  typescript = true,
  ['typescriptreact'] = true,
  ['typescript.tsx'] = true,
}

M.active_typescript_lsp = 'tsgo'

function M.switch_typescript_lsp()
  local current = M.active_typescript_lsp
  local next_lsp = current == 'ts_ls' and 'tsgo' or 'ts_ls'

  -- Check if the next LSP binary is available
  local binary = next_lsp == 'tsgo' and 'tsgo' or 'typescript-language-server'
  if vim.fn.executable(binary) ~= 1 then
    vim.notify(('Cannot switch: %s is not installed'):format(binary), vim.log.levels.WARN)
    return
  end

  -- Stop current TypeScript LSP clients
  for _, client in ipairs(vim.lsp.get_clients()) do
    if vim.tbl_contains(M.typescript_lsps, client.name) then
      vim.lsp.stop_client(client.id)
    end
  end

  -- Toggle the LSP configs
  vim.lsp.enable(current, false)
  vim.lsp.enable(next_lsp, true)

  -- Re-trigger LSP for TypeScript buffers
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local ft = vim.bo[buf].filetype
    if M.typescript_lsp_filetypes[ft] and vim.api.nvim_buf_is_loaded(buf) then
      vim.defer_fn(function()
        vim.api.nvim_exec_autocmds('FileType', { pattern = ft, buffer = buf })
      end, 200)
    end
  end

  M.active_typescript_lsp = next_lsp
  vim.notify(('Switched TypeScript LSP: %s → %s'):format(current, next_lsp), vim.log.levels.INFO)
end

-- Commands
vim.api.nvim_create_user_command('TypescriptSwitchLsp', function()
  M.switch_typescript_lsp()
end, { desc = 'Switch between ts_ls and tsgo TypeScript LSP servers' })

vim.api.nvim_create_user_command('TsSwitch', function()
  M.switch_typescript_lsp()
end, { desc = 'Switch TypeScript LSP server' })

-- Keymap
vim.keymap.set('n', '<leader>ts', function()
  M.switch_typescript_lsp()
end, { desc = 'Switch TypeScript LSP server' })

return M