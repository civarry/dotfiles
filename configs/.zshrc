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

# ngrok completion
if command -v ngrok &>/dev/null; then
    eval "$(ngrok completion)"
fi

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
# ALIASES & FUNCTIONS - N8N
# ============================================

# ============================================
# ALIASES & FUNCTIONS - N8N
# ============================================

n8n-start() {
  echo "🚀 Starting n8n..."
  cd ~/n8n-compose && docker compose up -d
  
  echo "📡 Starting ngrok in background..."
  # Kill any existing ngrok session
  tmux kill-session -t ngrok 2>/dev/null
  pkill ngrok 2>/dev/null
  
  # Start ngrok in a detached tmux session
  tmux new-session -d -s ngrok "ngrok http 5678"
  
  sleep 2
  echo ""
  echo "✅ n8n started!"
  echo "✅ ngrok started in background"
  echo ""
  echo "🌐 Access: https://leah-subpalmated-ai.ngrok-free.dev/home/workflows"
  echo ""
  echo "💡 Commands:"
  echo "   • Open in browser: n8n-open"
  echo "   • View ngrok logs: n8n-ngrok (Ctrl+B, D to exit)"
  echo "   • Check status: n8n-status"
  echo "   • Stop everything: n8n-stop"
}

n8n-stop() {
  echo "🛑 Stopping n8n..."
  cd ~/n8n-compose && docker compose stop
  
  echo "🛑 Stopping ngrok..."
  tmux kill-session -t ngrok 2>/dev/null
  pkill ngrok 2>/dev/null
  
  echo ""
  echo "✅ Everything stopped!"
}

alias n8n-restart="cd ~/n8n-compose && docker compose restart && echo '✅ n8n restarted!'"
alias n8n-logs="cd ~/n8n-compose && docker compose logs -f n8n"
alias n8n-ngrok="tmux attach -t ngrok"
alias n8n-status="echo '📊 N8N Status:' && docker ps | grep n8n && echo '\n📡 Ngrok Status:' && (tmux ls 2>/dev/null | grep ngrok && echo '✅ Running' || echo '❌ Not running')"
alias n8n-cd="cd ~/n8n-compose"
alias n8n-url="echo 'https://leah-subpalmated-ai.ngrok-free.dev/home/workflows' | pbcopy && echo '✅ URL copied to clipboard!\n🌐 https://leah-subpalmated-ai.ngrok-free.dev/home/workflows'"
alias n8n-open="open https://leah-subpalmated-ai.ngrok-free.dev/home/workflows"

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
# Android Emulator
# ============================================

alias startemu="~/Library/Android/sdk/emulator/emulator -avd Medium_Phone_API_36.1"

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
  echo "🤖 N8N AUTOMATION"
  echo "  n8n-start       Start n8n with Docker"
  echo "  n8n-stop        Stop n8n"
  echo "  n8n-restart     Restart n8n"
  echo "  n8n-logs        View n8n logs (Ctrl+C to exit)"
  echo "  n8n-status      Check if n8n is running"
  echo "  n8n-cd          Go to n8n directory"
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
export PATH="$HOME/.local/bin:$PATH"
# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/cjcarito/.lmstudio/bin"
# End of LM Studio CLI section

