# ============================================
# OH MY ZSH CONFIGURATION
# ============================================

# Path to your Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme (using Starship instead)
ZSH_THEME=""

# Plugins
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  z
  docker
  npm
  python
  macos
)

source $ZSH/oh-my-zsh.sh

# ============================================
# EXPORTS & PATH
# ============================================

export PATH="/opt/homebrew/opt/python@3.13/libexec/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export PATH="/opt/homebrew/opt/node@22/bin:$PATH"

# ============================================
# STARSHIP PROMPT
# ============================================

eval "$(starship init zsh)"

# Display system info on terminal start (only in top-level shells)
if [[ $SHLVL -eq 1 ]]; then
  fastfetch
fi

# ============================================
# HISTORY CONFIGURATION
# ============================================

HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY

# ============================================
# ALIASES - NAVIGATION
# ============================================

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias ~="cd ~"
alias -- -="cd -"

# ============================================
# ALIASES - GIT
# ============================================

alias gs="git status"
alias ga="git add"
alias gc="git commit -m"
alias gp="git push"
alias gl="git pull"
alias gd="git diff"
alias gco="git checkout"
alias gb="git branch"
alias glog="git log --oneline --graph --decorate"

# ============================================
# ALIASES - FILE OPERATIONS
# ============================================

# Modern replacements (install with: brew install bat eza)
alias cat="bat"
alias ls="eza --icons"
alias ll="eza -la --icons --git"
alias la="eza -a --icons"
alias tree="eza --tree --icons"

# ============================================
# ALIASES - PYTHON & PIP
# ============================================

alias python="python3"
alias pip="pip3"

# ============================================
# ALIASES - SYSTEM & NETWORK
# ============================================

alias ports="lsof -PiTCP -sTCP:LISTEN"
alias myip="curl ifconfig.me"
alias localip="ipconfig getifaddr en0"
alias flushdns="sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder"

# ============================================
# ALIASES - CONFIGURATION FILES
# ============================================

alias zshconfig="code ~/.zshrc"
alias starconfig="code ~/.config/starship.toml"
alias ffconfig="code ~/.config/fastfetch/config.jsonc"
alias reload="source ~/.zshrc"

# ============================================
# ALIASES - DEVELOPMENT
# ============================================

alias serve="python3 -m http.server"
alias venv="python3 -m venv venv && source venv/bin/activate"

# ============================================
# MACOS TWEAKS & OPTIMIZATIONS
# ============================================

# Remove Dock autohide delay
alias dock-fast="defaults write com.apple.dock autohide-delay -float 0 && killall Dock && echo '✅ Dock delay removed'"

# Restore default Dock delay
alias dock-normal="defaults delete com.apple.dock autohide-delay && killall Dock && echo '✅ Dock delay restored to default'"

# Apply all macOS optimizations
mac-optimize() {
  echo "🚀 Applying macOS optimizations..."
  echo ""

  echo "⚡️ Removing Dock autohide delay..."
  defaults write com.apple.dock autohide-delay -float 0

  echo "⚡️ Speeding up Mission Control animations..."
  defaults write com.apple.dock expose-animation-duration -float 0.1

  echo "⚡️ Enabling App Exposé swipe gesture..."
  defaults write com.apple.dock showAppExposeGestureEnabled -bool true

  echo "⚡️ Showing hidden files in Finder..."
  defaults write com.apple.finder AppleShowAllFiles -bool true

  echo "⚡️ Showing file extensions in Finder..."
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true

  echo "⚡️ Disabling .DS_Store on network volumes..."
  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

  echo "⚡️ Enabling snap-to-grid for icons..."
  /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

  echo ""
  echo "🔄 Restarting Dock and Finder..."
  killall Dock
  killall Finder

  echo ""
  echo "✅ macOS optimizations applied!"
  echo ""
  echo "💡 To revert: mac-restore-defaults"
}

# Restore default macOS settings
mac-restore-defaults() {
  echo "🔄 Restoring default macOS settings..."
  echo ""

  defaults delete com.apple.dock autohide-delay
  defaults delete com.apple.dock expose-animation-duration
  defaults write com.apple.finder AppleShowAllFiles -bool false
  defaults write NSGlobalDomain AppleShowAllExtensions -bool false
  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool false

  killall Dock
  killall Finder

  echo ""
  echo "✅ Defaults restored!"
}

# ============================================
# MAC MAINTENANCE COMMAND
# ============================================
unalias mactain 2>/dev/null  # Remove any existing alias
mactain() {
  echo "Starting Mac Maintenance..."
  echo ""
  echo "Updating Homebrew..."
  brew update
  echo ""
  echo "Upgrading packages..."
  brew upgrade
  echo ""
  echo "Upgrading apps..."
  brew upgrade --cask --greedy
  echo ""
  echo "Cleaning Homebrew..."
  brew cleanup && brew cleanup --prune=all
  echo ""
  echo "Emptying trash..."
  rm -rf ~/.Trash/* 2>/dev/null || true
  echo ""
  echo "Clearing user caches..."
  rm -rf ~/Library/Caches/* 2>/dev/null || true
  echo ""
  echo "Flushing DNS..."
  sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder
  echo ""
  echo "✅ Mac maintenance complete!"
}

# ============================================
# CUSTOM FUNCTIONS
# ============================================

# Make directory and cd into it
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Extract any archive
extract() {
  if [ -f $1 ]; then
    case $1 in
      *.tar.bz2)   tar xjf $1     ;;
      *.tar.gz)    tar xzf $1     ;;
      *.bz2)       bunzip2 $1     ;;
      *.rar)       unrar e $1     ;;
      *.gz)        gunzip $1      ;;
      *.tar)       tar xf $1      ;;
      *.tbz2)      tar xjf $1     ;;
      *.tgz)       tar xzf $1     ;;
      *.zip)       unzip $1       ;;
      *.Z)         uncompress $1  ;;
      *.7z)        7z x $1        ;;
      *)           echo "'$1' cannot be extracted" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Quickly search command history
h() {
  history | grep "$1"
}

# Kill process on port
killport() {
  lsof -ti:$1 | xargs kill -9
}

# ============================================
# HELP SYSTEM - View all shortcuts
# ============================================

alias shortcuts="zsh-help"
alias help="zsh-help"
alias cheat="zsh-help"

zsh-help() {
  echo ""
  echo "╔════════════════════════════════════════════════════════════════╗"
  echo "║                    ZSH SHORTCUTS & COMMANDS                    ║"
  echo "╚════════════════════════════════════════════════════════════════╝"
  echo ""
  echo "📁 NAVIGATION"
  echo "  ..              Go up one directory"
  echo "  ...             Go up two directories"
  echo "  ....            Go up three directories"
  echo "  ~               Go to home directory"
  echo "  -               Go to previous directory"
  echo "  mkcd <dir>      Create directory and cd into it"
  echo ""
  echo "📋 FILE OPERATIONS"
  echo "  ls              List files (with icons)"
  echo "  ll              List all files detailed (with icons & git)"
  echo "  la              List all files (with icons)"
  echo "  tree            Show directory tree (with icons)"
  echo "  cat <file>      View file with syntax highlighting"
  echo "  extract <file>  Extract any archive format"
  echo ""
  echo "🔧 GIT COMMANDS"
  echo "  gs              git status"
  echo "  ga              git add"
  echo "  gc \"msg\"        git commit -m \"msg\""
  echo "  gp              git push"
  echo "  gl              git pull"
  echo "  gd              git diff"
  echo "  gco             git checkout"
  echo "  gb              git branch"
  echo "  glog            git log (pretty)"
  echo ""
  echo "🐍 PYTHON"
  echo "  python          python3"
  echo "  pip             pip3"
  echo "  venv            Create and activate virtual environment"
  echo "  serve           Start HTTP server in current directory"
  echo ""
  echo "🌐 NETWORK & SYSTEM"
  echo "  myip            Show public IP address"
  echo "  localip         Show local IP address"
  echo "  ports           Show all listening ports"
  echo "  killport <num>  Kill process on specified port"
  echo "  flushdns        Flush DNS cache"
  echo ""
  echo "⚙️  CONFIGURATION"
  echo "  zshconfig       Edit .zshrc"
  echo "  starconfig      Edit starship config"
  echo "  ffconfig        Edit fastfetch config"
  echo "  reload          Reload .zshrc"
  echo ""
  echo "🔄 MAINTENANCE"
  echo "  mactain         Run full Mac maintenance"
  echo ""
  echo "⚡️ MACOS TWEAKS"
  echo "  dock-fast       Remove Dock autohide delay (instant show)"
  echo "  dock-normal     Restore default Dock delay"
  echo "  mac-optimize    Apply all macOS optimizations"
  echo "  mac-restore-defaults  Restore all macOS defaults"
  echo ""
  echo "🔍 UTILITIES"
  echo "  h <query>       Search command history"
  echo "  shortcuts       Show this help menu"
  echo "  help            Show this help menu"
  echo "  cheat           Show this help menu"
  echo ""
  echo "════════════════════════════════════════════════════════════════"
  echo ""
}

# ============================================
# FZF FUZZY FINDER (Optional)
# ============================================

# Uncomment if you have fzf installed (brew install fzf)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

# ============================================
# WELCOME MESSAGE
# ============================================

# Uncomment to show a tip on startup
# echo "💡 Tip: Type 'shortcuts' to see all available commands!"

