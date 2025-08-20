# Dotfiles Updates - Major Workflow Improvements

## 🚀 Overview
Major overhaul focusing on workflow consistency, plugin consolidation, and enhanced terminal/tmux integration.

## 📦 Neovim Changes

### Plugin Consolidation
- **Replaced dressing.nvim** → **mini.pick**: Consolidated UI selection with better integration
- **Replaced fzf-lua** → **mini.pick + mini.extra**: Unified picker experience with LSP integration
- **Removed unused plugins**: dap.lua, harpoon.lua, supermaven.lua, toggleterm.lua (cleanup)

### Enhanced Mini.nvim Integration
- **Added mini.extra**: Extended mini.pick with LSP pickers (document symbols, references, implementations, etc.)
- **Enhanced mini.hipatterns**: 
  - Color word highlighting (red, blue, green, etc. show in their actual colors)
  - Sensitive information censoring (passwords, API keys, tokens)
  - .env file value censoring
  - ToggleCensor command with `<leader>tc` keybinding

### Improved Formatting Workflow
- **Smart formatter conditions**: biome and prettier only run when config files exist
- **Biome LSP integration**: Only attaches to projects with biome.json/biome.jsonc
- **Format notifications**: Shows which formatter was used on manual format

### Updated Keybindings
- `<leader>ff` → Find files (mini.pick)
- `<leader>fg` → Live grep (mini.pick) 
- `<leader>fb` → Find buffers (mini.pick)
- `<leader>tc` → Toggle censoring
- All LSP keybindings now use mini.extra pickers

## 🖥️ Terminal & Shell Improvements  

### Enhanced Command History
- **FZF history integration**: `Ctrl+R` now uses fuzzy search interface
- **Multiple history modes**:
  - `Ctrl+R`: Basic fuzzy history search
  - `Ctrl+Alt+R`: History with timestamps
  - `Ctrl+Shift+R`: Global history across tmux sessions
- **Increased history**: 5k → 50k commands with better deduplication

### Autosuggestions Enhancement
- **`Ctrl+Y`**: Accept suggestions (consistent with nvim pickers)
- **Additional bindings**: Alt+F (accept), Alt+W (accept+execute), Alt+C (clear)
- **Better styling**: Matches TokyoNight theme
- **Dual strategy**: Uses both history and completion sources

## 🔄 Tmux Integration Fixes

### Navigation Improvements
- **Fixed bidirectional navigation**: `Ctrl+hjkl` now works from terminal panes back to nvim
- **Smart pane switching**: Detects vim/nvim processes and routes keys appropriately
- **Copy mode support**: Navigation works in tmux copy mode

## 🔧 Technical Improvements

### Code Quality
- **Conditional formatting**: Only runs when project has appropriate config files
- **Better error handling**: Format notifications show success/failure states
- **Performance optimizations**: Limited autosuggestion buffer sizes
- **Theme consistency**: All components now match TokyoNight styling

### Security Enhancements
- **Automatic censoring**: Sensitive values hidden by default in code
- **Toggle functionality**: Easy reveal/hide with notifications
- **Pattern coverage**: Handles passwords, API keys, tokens, and .env files

## 🎯 Workflow Benefits

1. **Consistency**: Same `Ctrl+Y` behavior in nvim pickers and terminal suggestions
2. **Intelligence**: Formatters and LSP only activate when configured
3. **Productivity**: Enhanced history search and autosuggestions
4. **Security**: Automatic sensitive data protection
5. **Integration**: Seamless tmux ↔ nvim navigation
6. **Consolidation**: Fewer plugins with better integration

## 📁 Files Modified
- `nvim/`: Major plugin restructure and configuration updates
- `tmux/.config/tmux/tmux.conf`: Navigation fixes and enhancements  
- `zsh/.zshrc`: History, completion, and autosuggestion improvements
