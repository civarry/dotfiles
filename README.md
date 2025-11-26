# Oh My Zsh Auto-Install Script

Automatically install and configure a complete Oh My Zsh setup with all plugins, themes, CLI tools, and custom configurations.

## What Gets Installed

### Shell Framework & Theming
- **Oh My Zsh** - Powerful zsh framework
- **Starship** - Fast, customizable prompt with icons
- **Zsh Plugins**:
  - `zsh-autosuggestions` - Fish-like autosuggestions
  - `zsh-syntax-highlighting` - Syntax highlighting for commands

### CLI Tools
- **fastfetch** - System information display
- **bat** - Modern cat replacement with syntax highlighting
- **eza** - Modern ls replacement with icons
- **fzf** - Fuzzy finder for files and history
- **fd** - Modern find replacement

### Development Tools
- **Python 3.13** - Latest Python version
- **Node.js 22** - Latest Node.js LTS

### Configuration Files
All your custom configurations including:
- ✅ **50+ aliases** (navigation, git, files, system, python)
- ✅ **Custom functions** (mkcd, extract, h, killport, mactain)
- ✅ **Complete help system** (shortcuts, help, cheat commands)
- ✅ **Starship theme** with custom icons
- ✅ **Fastfetch config** with custom layout and ASCII cat logo
- ✅ **FZF integration** with custom settings
- ✅ **History configuration**
- ✅ **PATH exports**

## Prerequisites

- macOS (tested on macOS 10.15+)
- Internet connection
- Administrator access (for some installations)

## Quick Start

1. **Clone or download this repository:**
   ```bash
   cd ~
   # If you have this as a git repo:
   git clone <your-repo-url> dotfiles

   # Or if you already have the dotfiles folder:
   cd dotfiles
   ```

2. **Run the installation script:**
   ```bash
   ./install-setup.sh
   ```

3. **Follow the interactive prompts** - The script will ask for confirmation before each major step

4. **Restart your terminal** or run:
   ```bash
   source ~/.zshrc
   ```

## Installation Process

The script will guide you through 9 steps:

1. **Pre-flight Checks** - Verify system compatibility and internet connection
2. **Install Homebrew** - macOS package manager (if not already installed)
3. **Install Oh My Zsh** - Shell framework
4. **Install Zsh Plugins** - Autosuggestions and syntax highlighting
5. **Install Starship** - Modern prompt theme
6. **Install CLI Tools** - fastfetch, bat, eza, fzf, fd
7. **Install Dev Tools** - Python 3.13 and Node.js 22
8. **Backup Configs** - Backup existing configuration files
9. **Copy Configs** - Install new configuration files
10. **Finalize** - Set zsh as default shell and display summary

### Interactive Mode

The script runs in **interactive mode**, meaning:
- It will show you what's about to be installed at each step
- You can choose to skip any step by answering 'n' when prompted
- Already-installed components will be detected and skipped automatically
- You maintain full control throughout the installation

## What's Included in Your Config

### Navigation Aliases
```bash
..      # Go up one directory
...     # Go up two directories
....    # Go up three directories
~       # Go to home directory
-       # Go to previous directory
```

### Git Aliases
```bash
gs      # git status
ga      # git add
gc      # git commit -m
gp      # git push
gl      # git pull
gd      # git diff
gco     # git checkout
gb      # git branch
glog    # git log (pretty format)
```

### File Operations
```bash
cat     # bat (syntax highlighting)
ls      # eza (with icons)
ll      # eza -la (detailed list with git status)
la      # eza -a (show hidden files)
tree    # eza --tree (directory tree)
```

### Custom Functions
```bash
mkcd <dir>      # Create directory and cd into it
extract <file>  # Extract any archive format
h <query>       # Search command history
killport <num>  # Kill process on specified port
mactain         # Run complete Mac maintenance
```

### System Commands
```bash
shortcuts       # Show all available commands
help           # Show all available commands
cheat          # Show all available commands
```

## File Structure

```
dotfiles/
├── install-setup.sh          # Main installation script
├── configs/
│   ├── .zshrc               # Complete zsh configuration
│   ├── starship.toml        # Starship prompt theme
│   └── fastfetch/
│       ├── config.jsonc     # Fastfetch display config
│       └── cat_logo.txt     # Custom ASCII cat logo
└── README.md                # This file
```

## Backup & Safety

### Automatic Backups
Before overwriting any existing configuration files, the script automatically creates backups:
- `~/.zshrc` → `~/.zshrc.backup.YYYY-MM-DD-HHMMSS`
- `~/.config/starship.toml` → `~/.config/starship.toml.backup.YYYY-MM-DD-HHMMSS`
- `~/.config/fastfetch/config.jsonc` → Similar backup format
- `~/.config/fastfetch/cat_logo.txt` → Similar backup format

### Restore from Backup
If you want to restore your original configuration:
```bash
# Find your backup files
ls -la ~/.zshrc.backup.*

# Restore the one you want
cp ~/.zshrc.backup.2025-11-26-123456 ~/.zshrc
source ~/.zshrc
```

## Troubleshooting

### Script fails during installation
- Check `/tmp/zsh-setup-install.log` for error details
- Ensure you have internet connection
- Verify you have administrator privileges

### Homebrew not found after installation
```bash
# Add Homebrew to PATH manually
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
source ~/.zshrc
```

### Plugins not working
```bash
# Verify plugins are installed
ls ~/.oh-my-zsh/custom/plugins/

# If missing, reinstall:
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
```

### Starship prompt not showing
```bash
# Verify Starship is installed
which starship

# If installed but not showing:
echo 'eval "$(starship init zsh)"' >> ~/.zshrc
source ~/.zshrc
```

### FZF key bindings not working
```bash
# Run fzf install script manually
$(brew --prefix)/opt/fzf/install
```

## Uninstall / Rollback

### Complete Uninstall
```bash
# Remove Oh My Zsh
uninstall_oh_my_zsh

# Remove Homebrew packages
brew uninstall starship fastfetch bat eza fzf fd python@3.13 node@22

# Restore original configs from backup
cp ~/.zshrc.backup.YYYY-MM-DD-HHMMSS ~/.zshrc
```

### Partial Rollback
Just restore specific config files from your backups (see Backup & Safety section above).

## Customization

After installation, you can customize:

### Edit Zsh Configuration
```bash
zshconfig    # Opens .zshrc in VS Code
reload       # Reload .zshrc after changes
```

### Edit Starship Theme
```bash
starconfig   # Opens starship.toml in VS Code
```

### Edit Fastfetch Display
```bash
ffconfig     # Opens fastfetch config in VS Code
```

## Manual Installation (Alternative)

If you prefer to install components manually:

```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# Install tools
brew install starship fastfetch bat eza fzf fd python@3.13 node@22

# Copy config files
cp configs/.zshrc ~/.zshrc
cp configs/starship.toml ~/.config/starship.toml
mkdir -p ~/.config/fastfetch
cp configs/fastfetch/* ~/.config/fastfetch/

# Reload
source ~/.zshrc
```

## Updates

To update all installed tools:

```bash
mactain      # Runs complete Mac maintenance
             # - Updates Homebrew
             # - Upgrades all packages
             # - Upgrades cask apps
             # - Cleans up old versions
             # - Empties trash
             # - Flushes DNS
```

Or individually:
```bash
brew update && brew upgrade    # Update Homebrew packages
omz update                     # Update Oh My Zsh
```

## Support

If you encounter issues:
1. Check the Troubleshooting section above
2. Review the installation log: `/tmp/zsh-setup-install.log`
3. Verify all prerequisites are met
4. Try running individual installation steps manually

## License

This is a personal configuration setup. Feel free to modify and adapt to your needs.

---

**Enjoy your new terminal setup!** 🚀

Type `shortcuts` or `help` to see all available commands.
