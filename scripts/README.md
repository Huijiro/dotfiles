# 🛠️ Dotfiles Scripts

Automation scripts for setting up and managing dotfiles.

## 📜 Available Scripts

### `initial_setup`
**Arch Linux automated setup script**

Installs all required packages and configurations for a complete development environment.

#### What it does:
1. **Installs paru** - AUR helper for package management
2. **Installs packages**:
   - `alacritty` - Terminal emulator
   - `starship` - Shell prompt
   - `neovim` - Text editor
   - `tmux` - Terminal multiplexer
   - `zsh` - Shell
   - `stow` - Configuration manager
   - `fzf`, `ripgrep`, `fd` - Search tools
   - `git`, `wl-clipboard` - Essential tools

3. **Sets up configurations**:
   - Stows all configuration files
   - Backs up existing configs
   - Sets zsh as default shell
   - Installs Zinit plugin manager
   - Installs Neovim plugins

#### Usage:
```bash
# Run the setup script
~/dotfiles/scripts/initial_setup

# Or if you're in the dotfiles directory
./scripts/initial_setup
```

#### Prerequisites:
- Arch Linux system
- Internet connection
- Sudo privileges

#### Safety Features:
- ✅ Backs up existing configurations with timestamps
- ✅ Checks if packages are already installed
- ✅ Exits on errors to prevent partial setup
- ✅ Colored output for clear status reporting

#### After Setup:
1. Restart terminal or run `exec zsh`
2. Open tmux and install plugins: `Ctrl+Space + I`
3. Enjoy your configured environment!

## 🚀 Future Scripts

This directory can be extended with additional automation scripts such as:
- `update_all` - Update all packages and plugins
- `backup_configs` - Backup current configurations
- `install_extras` - Install additional development tools
- `setup_desktop` - Configure window managers and desktop environment

## 🔧 Adding New Scripts

When adding new scripts:
1. Make them executable: `chmod +x script_name`
2. Add proper error handling with `set -e`
3. Include colored output for status messages
4. Document the script in this README
5. Test thoroughly before committing

## 💡 Tips

- Scripts assume you're running from the dotfiles directory
- All scripts should be idempotent (safe to run multiple times)
- Check system compatibility at the beginning of each script
- Always backup before making changes
