# Brewfile - Homebrew Bundle file for Mac setup
# Install all packages with: brew bundle install
# Note: brew bundle is now built into Homebrew core (no tap needed)

# Taps
tap "homebrew/cask"
tap "homebrew/cask-fonts"

# Core Utilities
brew "mas"              # Mac App Store command-line interface
brew "node"             # Node.js
brew "git"              # Version control
brew "wget"             # Internet file retriever
brew "curl"             # Transfer data with URLs
brew "zsh"              # Zsh shell
brew "tmux"             # Terminal multiplexer

# Development Tools
brew "gcc"              # GNU Compiler Collection
brew "cmake"            # Cross-platform make
brew "python@3.12"      # Python 3
brew "rustup"           # Rust toolchain installer
brew "jq"               # JSON processor
brew "ripgrep"          # Fast grep alternative
brew "fzf"              # Fuzzy finder
brew "tree"             # Directory tree display

# Applications
cask "emacs"            # Emacs editor
cask "iterm2"           # Better terminal emulator
cask "docker"           # Docker Desktop
cask "visual-studio-code"  # VS Code editor (optional)
cask "rectangle"        # Window management tool

# Fonts
cask "font-source-code-pro"
cask "font-fira-code"
cask "font-jetbrains-mono"

# Mac App Store Applications
# Evernote - Note taking app
mas "Evernote", id: 406056744

# Optional - Uncomment if needed
# mas "Xcode", id: 497799835
# mas "1Password", id: 1333542190
# mas "Slack", id: 803453959

# Post-install notes:
# - rustup requires initialization via `rustup-init` (handled by bootstrap.sh)
# - VS Code extensions should be installed separately
