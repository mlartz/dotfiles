#!/usr/bin/env bash

# bootstrap.sh - Set up a new Mac from scratch
# This script installs Homebrew and packages from Brewfile

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper functions
info() {
    echo -e "${GREEN}==>${NC} $1"
}

warn() {
    echo -e "${YELLOW}Warning:${NC} $1"
}

error() {
    echo -e "${RED}Error:${NC} $1"
    exit 1
}

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    error "This script is intended for macOS only"
fi

info "Starting Mac bootstrap process..."

# Install Homebrew if not already installed
if ! command -v brew &> /dev/null; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    info "Homebrew is already installed"
fi

# Update Homebrew
info "Updating Homebrew..."
brew update

# Install packages from Brewfile
# Note: brew bundle is now built into Homebrew core (no tap needed)
if [ -f "$HOME/dotfiles/Brewfile" ] || [ -f "$(dirname "$0")/Brewfile" ]; then
    info "Installing packages from Brewfile..."
    cd "$(dirname "$0")"
    brew bundle install --verbose
    info "All packages installed successfully!"
else
    warn "Brewfile not found. Skipping package installation."
fi

# Initialize rustup (Rust toolchain)
if ! command -v rustc &> /dev/null; then
    if command -v rustup-init &> /dev/null; then
        info "Initializing rustup..."
        rustup-init -y --no-modify-path
        # Source cargo environment for current session
        [ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"
        info "Rustup initialized successfully!"
    else
        warn "rustup-init not found. Install rustup via Homebrew first."
    fi
else
    info "Rust toolchain is already installed"
fi

# Prompt to run .macos configuration
echo ""
read -p "Do you want to apply macOS system defaults? (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [ -f "$HOME/dotfiles/.macos" ] || [ -f "$(dirname "$0")/.macos" ]; then
        info "Applying macOS defaults..."
        cd "$(dirname "$0")"
        chmod +x .macos
        ./.macos
    else
        warn ".macos file not found"
    fi
fi

info "Bootstrap complete!"
echo ""
echo "Next steps:"
echo "  1. Restart your terminal or run: source ~/.zshrc"
echo "  2. Configure iTerm2 with your preferred settings"
echo "  3. Sign in to Evernote from the App Store"
echo "  4. Set up your git credentials in .gitconfig.private"
echo ""
