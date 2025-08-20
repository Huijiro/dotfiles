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

### 🚀 Core Development Environment
- **[nvim/](nvim/)** - Modern Neovim configuration with mini.nvim ecosystem
- **[tmux/](tmux/)** - Terminal multiplexer with seamless Neovim integration  
- **[zsh/](zsh/)** - Enhanced shell with fuzzy history and smart completions

### 🖥️ Terminal Emulators
- **[alacritty/](alacritty/)** - GPU-accelerated terminal emulator
- **[kitty/](kitty/)** - Feature-rich terminal with advanced capabilities
- **[ghostty/](ghostty/)** - Modern terminal emulator configuration

### 🪟 Window Managers & Desktop Environment  
- **[hyprland/](hyprland/)** - Dynamic tiling Wayland compositor
- **[laptop-hyperland/](laptop-hyperland/)** - Laptop-specific Hyprland config
- **[i3/](i3/)** - Classic i3 window manager configuration
- **[waybar/](waybar/)** - Wayland status bar 
- **[laptop-waybar/](laptop-waybar/)** - Laptop-specific Waybar config
- **[picom/](picom/)** - X11 compositor for transparency and effects

### 🛠️ Development & System Tools
- **[starship/](starship/)** - Cross-shell prompt configuration
- **[lazydocker/](lazydocker/)** - Terminal UI for Docker management
- **[walker/](walker/)** - Application launcher configuration

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

Each configuration is organized in its own directory and can be installed independently with stow. Browse the individual directories for specific configuration details.

## 🎨 Theme

Consistent **TokyoNight** theming across configured tools:
- Neovim: TokyoNight colorscheme
- Tmux: Custom TokyoNight status bar
- Shell: Default zsh prompt (Starship config available in starship/)

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
