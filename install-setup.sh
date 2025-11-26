#!/bin/bash

# ============================================
# OH MY ZSH AUTO-INSTALL SCRIPT
# ============================================
# This script installs and configures a complete
# Oh My Zsh setup with all plugins, themes, and tools
# ============================================

set -e  # Exit on error (but we'll handle errors ourselves)

# ============================================
# COLOR CODES
# ============================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ============================================
# UTILITY FUNCTIONS
# ============================================

print_header() {
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║          OH MY ZSH AUTO-INSTALL SCRIPT                        ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_step() {
    echo ""
    echo -e "${BLUE}[Step $1/$2]${NC} ${CYAN}$3${NC}"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${YELLOW}→${NC} $1"
}

confirm() {
    while true; do
        read -p "$(echo -e "${YELLOW}Continue? (y/n):${NC} ")" yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer y or n.";;
        esac
    done
}

check_command() {
    command -v "$1" &>/dev/null
}

backup_file() {
    local file=$1
    if [ -f "$file" ] || [ -d "$file" ]; then
        local timestamp=$(date +%Y-%m-%d-%H%M%S)
        local backup="${file}.backup.${timestamp}"
        cp -r "$file" "$backup"
        print_success "Backed up $file to $backup"
    fi
}

log_error() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $1" >> /tmp/zsh-setup-install.log
}

# ============================================
# PRE-FLIGHT CHECKS
# ============================================

preflight_checks() {
    print_step "0" "9" "Pre-flight Checks"

    # Check if running on macOS
    if [[ "$OSTYPE" != "darwin"* ]]; then
        print_error "This script is designed for macOS only"
        exit 1
    fi
    print_success "Running on macOS"

    # Check internet connection
    if ! ping -c 1 google.com &>/dev/null; then
        print_error "No internet connection detected"
        exit 1
    fi
    print_success "Internet connection verified"

    # Display what will be installed
    echo ""
    echo -e "${CYAN}The following components will be installed:${NC}"
    echo ""
    echo -e "${YELLOW}Package Manager:${NC}"
    print_info "Homebrew (if not installed)"
    echo ""
    echo -e "${YELLOW}Shell Framework & Theming:${NC}"
    print_info "Oh My Zsh"
    print_info "Zsh plugins: autosuggestions, syntax-highlighting"
    print_info "Starship prompt"
    echo ""
    echo -e "${YELLOW}CLI Tools:${NC}"
    print_info "fastfetch, bat, eza, fzf, fd"
    echo ""
    echo -e "${YELLOW}Development Tools:${NC}"
    print_info "Python 3.13"
    print_info "Node.js 22"
    print_info "OpenJDK (required for Spark)"
    echo ""
    echo -e "${YELLOW}Configuration Files:${NC}"
    print_info "~/.zshrc (with ALL your aliases and functions)"
    print_info "~/.config/starship.toml"
    print_info "~/.config/fastfetch/config.jsonc"
    print_info "~/.config/fastfetch/cat_logo.txt"
    echo ""
}

# ============================================
# INSTALLATION FUNCTIONS
# ============================================

install_homebrew() {
    print_step "1" "9" "Install Homebrew"

    if check_command brew; then
        print_success "Homebrew already installed ($(brew --version | head -n1))"
        return 0
    fi

    print_info "Installing Homebrew..."
    if ! confirm; then
        print_info "Skipping Homebrew installation"
        return 1
    fi

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    if check_command brew; then
        print_success "Homebrew installed successfully"
    else
        print_error "Homebrew installation failed"
        log_error "Homebrew installation failed"
        return 1
    fi
}

install_ohmyzsh() {
    print_step "2" "9" "Install Oh My Zsh"

    if [ -d "$HOME/.oh-my-zsh" ]; then
        print_success "Oh My Zsh already installed"
        return 0
    fi

    print_info "Installing Oh My Zsh..."
    if ! confirm; then
        print_info "Skipping Oh My Zsh installation"
        return 1
    fi

    # Install Oh My Zsh without running zsh at the end
    RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    if [ -d "$HOME/.oh-my-zsh" ]; then
        print_success "Oh My Zsh installed successfully"
    else
        print_error "Oh My Zsh installation failed"
        log_error "Oh My Zsh installation failed"
        return 1
    fi
}

install_zsh_plugins() {
    print_step "3" "9" "Install Zsh Plugins"

    print_info "zsh-autosuggestions"
    print_info "zsh-syntax-highlighting"

    if ! confirm; then
        print_info "Skipping Zsh plugins installation"
        return 1
    fi

    # Install zsh-autosuggestions
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
        print_success "zsh-autosuggestions installed"
    else
        print_success "zsh-autosuggestions already installed"
    fi

    # Install zsh-syntax-highlighting
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
        print_success "zsh-syntax-highlighting installed"
    else
        print_success "zsh-syntax-highlighting already installed"
    fi
}

install_starship() {
    print_step "4" "9" "Install Starship"

    if check_command starship; then
        print_success "Starship already installed ($(starship --version))"
        return 0
    fi

    print_info "Installing Starship prompt..."
    if ! confirm; then
        print_info "Skipping Starship installation"
        return 1
    fi

    brew install starship

    if check_command starship; then
        print_success "Starship installed successfully"
    else
        print_error "Starship installation failed"
        log_error "Starship installation failed"
        return 1
    fi
}

install_cli_tools() {
    print_step "5" "9" "Install CLI Tools"

    print_info "fastfetch - System info display"
    print_info "bat - Modern cat replacement"
    print_info "eza - Modern ls replacement"
    print_info "fzf - Fuzzy finder"
    print_info "fd - Modern find replacement"

    if ! confirm; then
        print_info "Skipping CLI tools installation"
        return 1
    fi

    local tools=("fastfetch" "bat" "eza" "fzf" "fd")

    for tool in "${tools[@]}"; do
        if check_command "$tool"; then
            print_success "$tool already installed"
        else
            print_info "Installing $tool..."
            if brew install "$tool"; then
                print_success "$tool installed successfully"
            else
                print_error "$tool installation failed"
                log_error "$tool installation failed"
            fi
        fi
    done

    # Run fzf install script for shell integration
    if check_command fzf && [ -f "$(brew --prefix)/opt/fzf/install" ]; then
        print_info "Setting up fzf shell integration..."
        "$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc
        print_success "fzf shell integration configured"
    fi
}

install_dev_tools() {
    print_step "6" "9" "Install Development Tools"

    print_info "Python 3.13"
    print_info "Node.js 22"
    print_info "OpenJDK (required for Spark)"

    if ! confirm; then
        print_info "Skipping development tools installation"
        return 1
    fi

    # Install Python 3.13
    if brew list python@3.13 &>/dev/null; then
        print_success "Python 3.13 already installed"
    else
        print_info "Installing Python 3.13..."
        if brew install python@3.13; then
            print_success "Python 3.13 installed successfully"
        else
            print_error "Python 3.13 installation failed"
            log_error "Python 3.13 installation failed"
        fi
    fi

    # Install Node.js 22
    if brew list node@22 &>/dev/null; then
        print_success "Node.js 22 already installed"
    else
        print_info "Installing Node.js 22..."
        if brew install node@22; then
            print_success "Node.js 22 installed successfully"
        else
            print_error "Node.js 22 installation failed"
            log_error "Node.js 22 installation failed"
        fi
    fi

    # Install OpenJDK
    if brew list openjdk &>/dev/null; then
        print_success "OpenJDK already installed"
    else
        print_info "Installing OpenJDK..."
        if brew install openjdk; then
            print_success "OpenJDK installed successfully"
        else
            print_error "OpenJDK installation failed"
            log_error "OpenJDK installation failed"
        fi
    fi
}

backup_configs() {
    print_step "7" "9" "Backup Existing Configurations"

    print_info "Creating backups of existing config files..."

    if ! confirm; then
        print_info "Skipping backup"
        return 1
    fi

    backup_file "$HOME/.zshrc"
    backup_file "$HOME/.config/starship.toml"
    backup_file "$HOME/.config/fastfetch/config.jsonc"
    backup_file "$HOME/.config/fastfetch/cat_logo.txt"

    print_success "Backups completed"
}

copy_configs() {
    print_step "8" "9" "Copy Configuration Files"

    print_info "Installing configuration files..."
    print_info "This includes ALL your aliases, functions, and customizations"

    if ! confirm; then
        print_info "Skipping configuration installation"
        return 1
    fi

    # Get the script directory
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    # Copy .zshrc
    if [ -f "$SCRIPT_DIR/configs/.zshrc" ]; then
        cp "$SCRIPT_DIR/configs/.zshrc" "$HOME/.zshrc"
        print_success "Copied .zshrc"
    else
        print_error ".zshrc not found in configs directory"
        log_error ".zshrc not found"
    fi

    # Create config directories if they don't exist
    mkdir -p "$HOME/.config"
    mkdir -p "$HOME/.config/fastfetch"

    # Copy starship.toml
    if [ -f "$SCRIPT_DIR/configs/starship.toml" ]; then
        cp "$SCRIPT_DIR/configs/starship.toml" "$HOME/.config/starship.toml"
        print_success "Copied starship.toml"
    else
        print_error "starship.toml not found in configs directory"
        log_error "starship.toml not found"
    fi

    # Copy fastfetch configs
    if [ -f "$SCRIPT_DIR/configs/fastfetch/config.jsonc" ]; then
        cp "$SCRIPT_DIR/configs/fastfetch/config.jsonc" "$HOME/.config/fastfetch/config.jsonc"
        print_success "Copied fastfetch/config.jsonc"
    else
        print_error "fastfetch/config.jsonc not found in configs directory"
        log_error "fastfetch/config.jsonc not found"
    fi

    if [ -f "$SCRIPT_DIR/configs/fastfetch/cat_logo.txt" ]; then
        cp "$SCRIPT_DIR/configs/fastfetch/cat_logo.txt" "$HOME/.config/fastfetch/cat_logo.txt"
        print_success "Copied fastfetch/cat_logo.txt"
    else
        print_error "fastfetch/cat_logo.txt not found in configs directory"
        log_error "fastfetch/cat_logo.txt not found"
    fi

    print_success "All configuration files installed"
}

finalize() {
    print_step "9" "9" "Finalize Installation"

    print_info "Setting zsh as default shell (if not already)..."

    if [[ "$SHELL" != */zsh ]]; then
        chsh -s "$(which zsh)"
        print_success "Default shell set to zsh"
    else
        print_success "zsh is already the default shell"
    fi

    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                 INSTALLATION COMPLETED!                        ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}What was installed:${NC}"
    print_success "Oh My Zsh with plugins (autosuggestions, syntax-highlighting)"
    print_success "Starship prompt"
    print_success "CLI tools (fastfetch, bat, eza, fzf, fd)"
    print_success "Development tools (Python 3.13, Node.js 22, OpenJDK)"
    print_success "All configuration files with your aliases and functions"
    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    print_info "Close this terminal and open a new one to see the changes"
    print_info "OR run: source ~/.zshrc"
    print_info "Type 'shortcuts' or 'help' to see all available commands"
    echo ""
    echo -e "${CYAN}Backups:${NC}"
    print_info "Your original configs were backed up with timestamps"
    print_info "Look for files with .backup.YYYY-MM-DD-HHMMSS extensions"
    echo ""
}

# ============================================
# MAIN EXECUTION
# ============================================

main() {
    # Clear the log file
    > /tmp/zsh-setup-install.log

    print_header

    preflight_checks

    # Run installation steps
    install_homebrew
    install_ohmyzsh
    install_zsh_plugins
    install_starship
    install_cli_tools
    install_dev_tools
    backup_configs
    copy_configs
    finalize
}

# Run main function
main
