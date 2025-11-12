# Brewfile - Homebrew Bundle file for Mac setup
# Install all packages with: brew bundle

# Taps
tap "homebrew/bundle"
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

# VS Code extensions and other post-install steps should be handled separately
# Rustup is installed via bootstrap.sh as it's not in Homebrew
