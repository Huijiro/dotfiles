---@brief
---
--- https://github.com/microsoft/typescript-go
---
--- TypeScript 7 (aka `tsgo`) is the Go-based native port of TypeScript by Microsoft.
--- This is a preview release - LSP support is "in progress" with most functionality working.
---
--- Installation via npm (recommended):
--- ```sh
--- npm install -g @typescript/native-preview
--- ```
---
--- Then use `npx tsgo` or add the npm bin directory to PATH.
---
--- Build from source:
--- ```sh
--- git clone https://github.com/microsoft/typescript-go
--- cd typescript-go
--- go build -o ~/.local/bin/tsgo ./cmd/tsgo
--- ```
---
--- Status (from README):
--- - Type checking: done
--- - LSP: in progress (most functionality works)
--- - Declaration emit: in progress
--- - Watch mode: prototype
---
--- This LSP is an alternative to `ts_ls` (Node.js-based typescript-language-server).
--- Use `:TypescriptSwitchLsp` or `:TsSwitch` to toggle between them.
---

---@type vim.lsp.Config
return {
  cmd = { 'tsgo', '--lsp', '-stdio' },
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
  },
  root_dir = function(bufnr, on_dir)
    local root_markers = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock', 'tsconfig.json',
      'jsconfig.json' }
    root_markers = vim.fn.has('nvim-0.11.3') == 1 and { root_markers, { '.git' } }
        or vim.list_extend(root_markers, { '.git' })
    local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()
    on_dir(project_root)
  end,
  on_attach = function(client, bufnr)
    -- Create source action command similar to ts_ls
    vim.api.nvim_buf_create_user_command(bufnr, 'LspTypescriptSourceAction', function()
      local source_actions = vim.tbl_filter(function(action)
        return vim.startswith(action, 'source.')
      end,
        client.server_capabilities.codeActionProvider and client.server_capabilities.codeActionProvider.codeActionKinds or
        {})

      vim.lsp.buf.code_action({
        context = {
          only = source_actions,
        },
      })
    end, {})
  end,
}

