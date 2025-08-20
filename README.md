# 🏠 Dotfiles

> I use Arch BTW

Personal configuration files managed with [GNU Stow](https://www.gnu.org/software/stow/) for a clean, modular dotfiles setup.

## 🚀 Quick Start

```bash
# Clone dotfiles
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Install individual configs with stow
stow nvim    # Neovim configuration
stow tmux    # Tmux configuration  
stow zsh     # Zsh shell configuration

# Or install everything at once
stow */
```

## 📦 What's Included

### 🎯 [Neovim](nvim/)
Modern Neovim setup focused on workflow consistency and intelligent tooling.

**Key Features:**
- **Plugin Management**: Lazy.nvim for fast startup
- **LSP Integration**: Mason + nvim-lspconfig with biome, TypeScript, Lua, C++
- **Fuzzy Finding**: Mini.pick for unified selection experience
- **Smart Formatting**: Biome/Prettier with project-aware activation
- **Security**: Automatic sensitive data censoring with toggle
- **Theme**: TokyoNight with consistent styling

**Notable Plugins:**
- `mini.nvim` - Swiss Army knife of Neovim plugins
- `blink.cmp` - Fast completion engine
- `conform.nvim` - Intelligent formatting
- `noice.nvim` - Enhanced UI messages

### 🖥️ [Tmux](tmux/)
Terminal multiplexer configuration with seamless Neovim integration.

**Key Features:**
- **Navigation**: Smart vim-tmux-navigator (bidirectional)
- **Theme**: TokyoNight matching Neovim
- **Session Management**: TMS integration for project sessions
- **Copy Mode**: Vi-style bindings with system clipboard
- **Status Bar**: Clean, informative status line

**Keybindings:**
- `Ctrl+Space` - Prefix key
- `Ctrl+h/j/k/l` - Navigate panes/vim splits
- `Ctrl+Space + S` - Session switcher

### 🐚 [Zsh](zsh/)
Enhanced shell experience with powerful history and completion.

**Key Features:**
- **History**: 50k commands with fuzzy search (Ctrl+R)
- **Autosuggestions**: Smart suggestions with Ctrl+Y acceptance
- **Completion**: Enhanced completions with case-insensitivity
- **Theme**: Starship prompt with git integration
- **Plugin Manager**: Zinit for fast plugin loading

**Keybindings:**
- `Ctrl+R` - Fuzzy history search
- `Ctrl+Y` - Accept autosuggestion (consistent with Neovim)
- `Ctrl+Alt+R` - History with timestamps

## 🔧 Installation

### Prerequisites
```bash
# Arch Linux
sudo pacman -S stow neovim tmux zsh fzf ripgrep fd git starship

# Ubuntu/Debian  
sudo apt install stow neovim tmux zsh fzf ripgrep fd-find git
curl -sS https://starship.rs/install.sh | sh
```

### Step-by-step Setup

1. **Clone Repository**
   ```bash
   git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. **Backup Existing Configs** (if any)
   ```bash
   mkdir ~/config-backup
   mv ~/.config/nvim ~/config-backup/ 2>/dev/null || true
   mv ~/.zshrc ~/config-backup/ 2>/dev/null || true
   mv ~/.config/tmux ~/config-backup/ 2>/dev/null || true
   ```

3. **Install Configurations**
   ```bash
   # Individual components
   stow nvim
   stow tmux  
   stow zsh
   
   # Or all at once
   stow */
   ```

4. **Set Zsh as Default Shell**
   ```bash
   chsh -s $(which zsh)
   ```

5. **Install Neovim Plugins**
   ```bash
   nvim --headless "+Lazy! install" +qa
   ```

6. **Install Tmux Plugins** (if using TPM)
   ```bash
   git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
   # In tmux: prefix + I to install plugins
   ```

## ⚙️ Customization

### Directory Structure
```
dotfiles/
├── nvim/.config/nvim/          # Neovim config
│   ├── lua/plugins/            # Plugin configurations
│   ├── init.lua               # Entry point
│   └── lazy-lock.json         # Plugin versions
├── tmux/.config/tmux/         # Tmux config
│   └── tmux.conf             # Main config
├── zsh/                       # Zsh config
│   └── .zshrc                # Shell configuration
└── CHANGELOG.md              # Recent changes
```

### Key Configuration Files

**Neovim:**
- [`init.lua`](nvim/.config/nvim/init.lua) - Entry point
- [`lua/plugins/mini.lua`](nvim/.config/nvim/lua/plugins/mini.lua) - Core functionality
- [`lua/plugins/comform.lua`](nvim/.config/nvim/lua/plugins/comform.lua) - Formatting setup

**Tmux:**
- [`tmux.conf`](tmux/.config/tmux/tmux.conf) - Complete tmux config

**Zsh:**
- [`.zshrc`](zsh/.zshrc) - Shell configuration with history and completion

## 🎨 Theme

Consistent **TokyoNight** theming across all tools:
- Neovim: TokyoNight colorscheme
- Tmux: Custom TokyoNight status bar
- Terminal: Starship prompt with matching colors

## 🔑 Key Workflow Features

### Consistent Keybindings
- `Ctrl+Y` - Accept selection (works in Neovim pickers AND terminal suggestions)
- `Ctrl+h/j/k/l` - Navigate seamlessly between tmux panes and vim splits
- `Ctrl+R` - Fuzzy search history in terminal
- `<leader>tc` - Toggle sensitive data censoring in Neovim

### Smart Tooling
- **Formatters** only activate when project config files exist
- **LSP servers** attach based on project configuration
- **Sensitive data** automatically censored in code files
- **History search** works across tmux sessions

### Security-First
- Automatic password/API key censoring
- .env file value protection
- Easy toggle for temporary reveal

## 📝 Recent Updates

See [CHANGELOG.md](CHANGELOG.md) for recent improvements including:
- Plugin consolidation (dressing.nvim → mini.pick)
- Enhanced tmux navigation fixes
- Fuzzy history search improvements
- Smart formatting conditions

## 🛠️ Managing Configurations

### Adding New Configurations
```bash
cd ~/dotfiles
mkdir -p newapp/.config/newapp
# Add your configs to newapp/.config/newapp/
stow newapp
```

### Updating
```bash
cd ~/dotfiles
git pull
stow --restow */  # Re-stow everything
```

### Removing
```bash
cd ~/dotfiles  
stow -D nvim  # Remove nvim stow links
```

## 🤝 Contributing

Feel free to fork and adapt these configurations! If you find improvements or fixes, pull requests are welcome.

## 📜 License

This project is licensed under the MIT License - feel free to use and modify as needed.

---

**Note**: These configurations are tailored for Arch Linux but should work on most Unix-like systems with minor adjustments.
