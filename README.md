# Dotfiles

Configuration files for Mac and Linux machines. These dotfiles include setup scripts, shell configurations, and system preferences.

## Quick Start (New Mac Setup)

### 1. Clone this repository

```bash
git clone https://github.com/mlartz/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 2. Run the bootstrap script

The bootstrap script will:
- Install Homebrew (if not already installed)
- Install all packages from the Brewfile (including rustup)
- Initialize Rust toolchain via rustup-init
- Optionally apply macOS system defaults

```bash
./bootstrap.sh
```

### 3. Symlink dotfiles

After the bootstrap completes, symlink the configuration files to your home directory:

```bash
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/dotfiles/.gitignore.global ~/.gitignore.global

# Emacs configuration
ln -sf ~/dotfiles/.emacs.d ~/.emacs.d

# Terminal theme
mkdir -p ~/.config
ln -sf ~/dotfiles/.config/gruvbox-dark.terminal ~/.config/
```

### 4. Configure private settings

Create a `.gitconfig.private` file for your personal git settings:

```bash
cat > ~/.gitconfig.private << EOF
[user]
    name = Your Name
    email = your.email@example.com
[credential]
    helper = osxkeychain
EOF
```

### 5. Restart your terminal

```bash
source ~/.zshrc
```

## What Gets Installed

### Homebrew Packages

The `Brewfile` installs:

#### Command-line Tools
- **mas** - Mac App Store CLI
- **node** - Node.js runtime
- **git** - Version control
- **tmux** - Terminal multiplexer
- **rustup** - Rust toolchain installer
- **ripgrep** - Fast grep alternative
- **fzf** - Fuzzy finder
- **jq** - JSON processor
- **wget**, **curl** - File downloaders
- **tree** - Directory visualization
- **gcc**, **cmake** - Build tools
- **python** - Python 3

#### Applications (Casks)
- **Emacs** - Text editor
- **iTerm2** - Terminal emulator
- **Docker** - Containerization
- **Rectangle** - Window management
- **Visual Studio Code** - Code editor

#### Fonts
- Source Code Pro
- Fira Code
- JetBrains Mono

#### Mac App Store Apps
- **Evernote** - Note-taking app

### Rust Installation

**rustup** (the Rust toolchain installer) is installed via Homebrew and automatically initialized by the bootstrap script.

**Why this approach?**
- The `rustup` binary is managed by Homebrew (declared in Brewfile)
- The bootstrap script runs `rustup-init` to set up the Rust toolchain
- This combines centralized package management with proper Rust toolchain handling
- Updates to the Rust toolchain are managed via `rustup update` (as recommended by the Rust project)
- The `--no-modify-path` flag is used since shell configuration is handled by dotfiles

## Files Overview

### Configuration Files

- **`.zshrc`** - Zsh shell configuration
- **`.tmux.conf`** - Tmux configuration with best practices
- **`.gitconfig`** - Git configuration
- **`.gitconfig.private`** - Private git settings (not in repo)
- **`.gitignore.global`** - Global gitignore patterns
- **`.emacs.d/`** - Emacs configuration
- **`.config/`** - Additional config files

### Setup Scripts

- **`bootstrap.sh`** - Main setup script for new Macs
- **`Brewfile`** - Homebrew Bundle file
- **`.macos`** - macOS system defaults and preferences

## macOS System Defaults

The `.macos` script configures hundreds of macOS system preferences including:

- UI/UX improvements (faster animations, better defaults)
- Trackpad and keyboard settings
- Finder preferences
- Dock configuration
- Safari and other app defaults
- Security and privacy settings

**Warning:** Review the `.macos` file before running it, as it makes extensive system changes. Some settings may require restart.

## Manual Steps

After running the bootstrap, you may want to:

1. **iTerm2 Configuration**
   - Import the Gruvbox Dark color scheme
   - Set font to a powerline-compatible font
   - Configure keyboard shortcuts

2. **Evernote Setup**
   - Launch Evernote from Applications
   - Sign in with your account

3. **System Preferences**
   - Configure Touch ID
   - Set up iCloud
   - Configure backup systems

4. **Development Tools**
   - Install IDE-specific plugins
   - Configure Docker settings
   - Set up SSH keys

## Updating

### Update Homebrew packages

```bash
brew update
brew upgrade
brew cleanup
```

### Update Rust

```bash
rustup update
```

### Update Node packages

```bash
npm update -g
```

## Customization

### Adding More Packages

Edit the `Brewfile` and add packages:

```ruby
brew "package-name"          # Command-line tools
cask "app-name"              # GUI applications
mas "App Name", id: 123456   # Mac App Store apps
```

Then run:

```bash
brew bundle
```

### Finding Mac App Store IDs

Use `mas` to search for app IDs:

```bash
mas search "app name"
```

## Linux Compatibility

Most configuration files work on Linux, but:
- Skip `bootstrap.sh` and `.macos` (Mac-only)
- Manually install packages using your distro's package manager
- Symlink configuration files as shown above

## Troubleshooting

### Homebrew not in PATH (Apple Silicon)

```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

### Permission errors with .macos

```bash
chmod +x .macos
```

### Rustup not found after installation

```bash
source ~/.cargo/env
```

## Credits

- The `.macos` script is based on [Mathias Bynens' dotfiles](https://github.com/mathiasbynens/dotfiles)
- Gruvbox Dark theme for Terminal
- Various configurations adapted from the community

## License

Feel free to use and modify these dotfiles for your own setup.
