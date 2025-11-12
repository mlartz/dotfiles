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
- Install all packages from the Brewfile using `brew bundle`
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

# Terminal and iTerm2 themes
mkdir -p ~/.config
ln -sf ~/dotfiles/.config/gruvbox-dark.terminal ~/.config/
ln -sf ~/dotfiles/.config/Gruvbox-Dark.itermcolors ~/.config/
ln -sf ~/dotfiles/.config/iterm2-gruvbox-profile.json ~/.config/
```

**Note:** The `.macos` script automatically copies the iTerm2 files to the appropriate locations, so manual symlinking of iTerm2 files is optional.

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
- **`.tmux.conf`** - Tmux configuration optimized for iTerm2 Control Mode and remote work
- **`.gitconfig`** - Git configuration
- **`.gitconfig.private`** - Private git settings (not in repo)
- **`.gitignore.global`** - Global gitignore patterns
- **`.emacs.d/`** - Emacs configuration
- **`.config/`** - Additional config files
  - **`gruvbox-dark.terminal`** - Gruvbox Dark theme for Terminal.app
  - **`Gruvbox-Dark.itermcolors`** - Gruvbox Dark color scheme for iTerm2
  - **`iterm2-gruvbox-profile.json`** - iTerm2 Dynamic Profile with SSH/tmux optimizations
  - **`mlartz.zsh-theme`** - Custom Zsh theme

### Setup Scripts

- **`bootstrap.sh`** - Main setup script for new Macs
- **`Brewfile`** - Homebrew Bundle file for package management
- **`.macos`** - macOS system defaults and preferences

### Remote Development Workflow

- **`REMOTE_WORKFLOW_SETUP.md`** - Complete guide for iTerm2 + tmux Control Mode
- **`ssh_config.example`** - SSH configuration template with ControlMaster
- **`tmux-work-session.sh`** - Automated workflow setup script

## macOS System Defaults

The `.macos` script configures hundreds of macOS system preferences including:

- UI/UX improvements (faster animations, better defaults)
- Trackpad and keyboard settings
- Finder preferences
- Dock configuration
- Safari and other app defaults
- Security and privacy settings

**Warning:** Review the `.macos` file before running it, as it makes extensive system changes. Some settings may require restart.

## Remote Development Workflow

This repository includes configuration for an optimized remote SSH development workflow using **iTerm2 + tmux Control Mode**.

**Benefits:**
- ✅ Native macOS scrolling with trackpad gestures
- ✅ Native window switching (Cmd+Tab, Mission Control)
- ✅ Full mouse support and native copy/paste
- ✅ Session persistence across disconnections

**Quick Setup:**
```bash
# 1. Configure SSH (see ssh_config.example)
cp ssh_config.example ~/.ssh/config
# Edit with your server details

# 2. Create control masters directory
mkdir -p ~/.ssh/controlmasters && chmod 700 ~/.ssh/controlmasters

# 3. Add shell alias to ~/.zshrc
echo "alias work='ssh devserver -t \"tmux -CC attach -t work || tmux -CC new -s work\"'" >> ~/.zshrc
source ~/.zshrc

# 4. Connect with Control Mode
work
```

**Full Documentation:** See [REMOTE_WORKFLOW_SETUP.md](REMOTE_WORKFLOW_SETUP.md) for complete setup guide, usage instructions, and troubleshooting.

**Files:**
- `REMOTE_WORKFLOW_SETUP.md` - Complete setup and usage guide
- `ssh_config.example` - SSH configuration template with ControlMaster
- `.tmux.conf` - Optimized tmux configuration for Control Mode
- `tmux-work-session.sh` - Automated workflow script (1 emacs + 3 shells)

## Manual Steps

After running the bootstrap, you may want to:

1. **iTerm2 Configuration**

   The `.macos` script automatically configures iTerm2 with Gruvbox Dark theme and best practices for SSH/tmux workflows.

   **What's Configured:**
   - Gruvbox Dark color scheme (optimized for readability)
   - 10,000 line scrollback buffer
   - UTF-8 encoding
   - xterm-256color terminal type (best compatibility)
   - GPU/Metal rendering for performance
   - Mouse reporting (for tmux mouse support)
   - Ligature support for Fira Code font
   - Smart cursor color
   - Visual bell (no audio bell)
   - Proper window/tab behavior for multi-session work

   **To Activate:**
   After running `.macos`, open iTerm2 and:
   - Go to Preferences → Profiles
   - Select "Gruvbox Dark" from the profile list
   - Click "Other Actions..." → "Set as Default"
   - Restart iTerm2 for all settings to take effect

   **Font Configuration:**
   - The profile uses Fira Code 13pt by default
   - You can change this in Preferences → Profiles → Text
   - Recommended fonts: Fira Code, JetBrains Mono, Source Code Pro (all installed via Brewfile)

   **SSH and Tmux Best Practices Included:**
   - Tmux integration mode enabled (use `tmux -CC` for native tmux windows)
   - Proper escape sequence handling for remote vim/emacs
   - Jobs whitelist configured (ssh, tmux won't trigger close warnings)
   - Clipboard access enabled for remote copy/paste
   - Safe paste settings (chunked, delayed) to prevent issues with remote shells

   **Pro Tips:**
   - Use `tmux -CC attach` to attach to remote tmux sessions with native iTerm2 tabs/windows
   - Cmd+Click on file paths opens them in your editor (even on remote servers with tmux integration)
   - The same .tmux.conf works seamlessly on both Mac and remote Linux servers
   - Mouse support in tmux is enabled - you can click to switch panes, scroll, resize, etc.

   **For Remote Development:** See [REMOTE_WORKFLOW_SETUP.md](REMOTE_WORKFLOW_SETUP.md) for complete workflow setup

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

### Managing Packages with Brewfile

**brew bundle is now built into Homebrew core** (no tap needed as of Homebrew 4.5.0)

#### Adding Packages

Edit the `Brewfile` and add packages:

```ruby
brew "package-name"          # Command-line tools
cask "app-name"              # GUI applications
mas "App Name", id: 123456   # Mac App Store apps
```

Then install new packages:

```bash
brew bundle install
```

#### Keeping Your Brewfile Up-to-Date

Generate a Brewfile from currently installed packages:

```bash
brew bundle dump --force
```

This creates/overwrites the Brewfile with all currently installed packages.

#### Cleanup Unused Packages

Remove packages not listed in the Brewfile:

```bash
brew bundle cleanup
```

Add `--force` to actually remove them (without it, it just shows what would be removed):

```bash
brew bundle cleanup --force
```

#### Check Brewfile Status

See if everything in your Brewfile is installed:

```bash
brew bundle check
```

List all packages from the Brewfile:

```bash
brew bundle list
```

#### Track Only "Leaves"

To keep your Brewfile minimal, consider tracking only "leaves" (packages you explicitly want, excluding dependencies):

```bash
brew leaves > leaves.txt
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
