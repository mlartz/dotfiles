# Remote Development Workflow Setup
# iTerm2 + tmux Control Mode

This guide will help you set up an optimized remote development workflow using iTerm2's Control Mode with tmux. This configuration provides:

- ✅ Native macOS scrolling with trackpad gestures
- ✅ Native window switching with Cmd+Tab and Mission Control
- ✅ Full mouse support for all operations
- ✅ Native copy/paste with macOS clipboard
- ✅ Session persistence across disconnections

## Overview

**What is iTerm2 Control Mode?**

iTerm2's Control Mode (`tmux -CC`) transforms tmux into a native Mac experience. Instead of running tmux inside a terminal window, iTerm2 communicates with tmux via a control protocol, rendering each tmux window/pane as a native macOS window or tab. You get all the power of tmux session management with the polish of native Mac window handling.

**The Result:** Each tmux window becomes a real Mac window that responds to all your familiar keyboard shortcuts and trackpad gestures.

## Prerequisites

- **macOS** with iTerm2 installed (download from https://iterm2.com)
- **Remote Linux server** with tmux installed
- **SSH access** to your remote server

## Setup Steps

### 1. Install Required Software

#### On Your Mac

```bash
# Install iTerm2 (if not already installed)
brew install --cask iterm2

# Or download from https://iterm2.com/downloads.html
```

#### On Your Remote Server

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install tmux

# CentOS/RHEL
sudo yum install tmux

# macOS (if using as remote server)
brew install tmux

# Verify tmux version (2.1+ required for mouse support)
tmux -V
```

### 2. Configure SSH Connection Multiplexing

SSH ControlMaster makes reconnections nearly instant by reusing existing connections.

**On your Mac**, copy the SSH config template:

```bash
cd ~/dotfiles
cp ssh_config.example ~/.ssh/config

# Or if you already have an SSH config, append the contents
cat ssh_config.example >> ~/.ssh/config
```

**Edit `~/.ssh/config`** and replace the example values:

```
Host devserver
    HostName your-actual-server.com
    User your-username
    Port 22
```

**Create the control masters directory:**

```bash
mkdir -p ~/.ssh/controlmasters
chmod 700 ~/.ssh/controlmasters
chmod 700 ~/.ssh
```

**Test the connection:**

```bash
# First connection creates the master socket
ssh devserver

# Open another terminal and connect again - should be instant!
ssh devserver

# Check if multiplexing is working
ssh -O check devserver
```

### 3. Set Up tmux Configuration on Remote Server

**On your remote server**, symlink the tmux configuration:

```bash
# Clone or sync your dotfiles to the remote server
git clone https://github.com/mlartz/dotfiles.git ~/dotfiles

# Symlink the configuration
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf

# Make the workflow script executable
chmod +x ~/dotfiles/tmux-work-session.sh
```

**Or manually copy the configuration:**

```bash
# Copy from your local machine to remote server
scp ~/dotfiles/.tmux.conf devserver:~/.tmux.conf
scp ~/dotfiles/tmux-work-session.sh devserver:~/tmux-work-session.sh
ssh devserver 'chmod +x ~/tmux-work-session.sh'
```

### 4. Create Shell Aliases

**On your Mac**, add these aliases to `~/.zshrc` or `~/.bashrc`:

```bash
# iTerm2 Control Mode - best for desktop work
alias work='ssh devserver -t "tmux -CC attach -t work || tmux -CC new -s work"'

# Automated workflow setup (1 emacs + 3 shells)
alias work-setup='ssh devserver -t "~/dotfiles/tmux-work-session.sh"'

# Standard tmux mode (for non-iTerm2 terminals)
alias work-standard='ssh devserver -t "tmux attach -t work || tmux new -s work"'
```

**Apply the changes:**

```bash
source ~/.zshrc  # or source ~/.bashrc
```

## Usage

### Starting Your Work Session

**Option 1: Automatic Setup (Recommended for First Time)**

```bash
work-setup
```

This creates a tmux session with:
- Window 0: Emacs editor
- Window 1: Shell 1
- Window 2: Shell 2
- Window 3: Shell 3

**Option 2: Control Mode with Existing Session**

```bash
work
```

This attaches to your existing "work" session or creates a new one if it doesn't exist.

### Working in Control Mode

Once connected with Control Mode:

1. **Each tmux window opens as a native Mac window**
   - Use Cmd+Tab to switch between them
   - Use Mission Control (three-finger swipe up) to see all windows
   - Minimize, maximize, and arrange like any Mac window

2. **Scrolling works natively**
   - Trackpad gestures work naturally
   - Mouse wheel scrolling works as expected
   - No need to enter tmux copy mode for scrolling

3. **Creating new windows/panes**
   - Cmd+T: New tmux window (opens as new Mac window)
   - Cmd+D: Split tmux pane vertically
   - Cmd+Shift+D: Split tmux pane horizontally
   - Or use traditional tmux commands (Ctrl+\ is the prefix)

4. **Copy/paste**
   - Cmd+C and Cmd+V work natively
   - Mouse selection automatically copies to clipboard
   - Double-click to select word, triple-click to select line

5. **Mouse operations**
   - Click to position cursor
   - Drag to resize panes
   - Click pane borders to select panes
   - Hold Option to bypass tmux mouse mode for terminal selection

### Session Management

**Detach from session (keeps running on server):**
```bash
# Press: Ctrl+\ d
# Or close all iTerm2 windows - session persists on server
```

**Reconnect to session:**
```bash
work  # Reconnects to existing session
```

**List all sessions:**
```bash
ssh devserver 'tmux ls'
```

**Kill a session:**
```bash
ssh devserver 'tmux kill-session -t work'
```

### Handling Disconnections

**Laptop sleep or network interruption:**
1. Your tmux session continues running on the remote server
2. SSH ControlMaster keeps the connection alive for 30 minutes
3. Simply run `work` again to reconnect
4. All your windows and processes are exactly as you left them

**For longer interruptions:**
- ControlMaster will close after 30 minutes
- Your tmux session still persists on the server indefinitely
- Reconnecting takes a few seconds to establish new SSH connection
- All your work is preserved

## Customization

### Customize Your Workflow Script

Edit `~/dotfiles/tmux-work-session.sh` to customize:

```bash
# Change window names
EMACS_WINDOW="editor"
SHELL1_WINDOW="git"
SHELL2_WINDOW="server"
SHELL3_WINDOW="commands"

# Add startup commands for each window
tmux send-keys -t "$SESSION_NAME:$SHELL1_WINDOW" 'cd ~/myproject && git status' C-m
tmux send-keys -t "$SESSION_NAME:$SHELL2_WINDOW" 'cd ~/myproject && npm start' C-m
```

### Customize tmux Key Bindings

Edit `~/.tmux.conf` on your remote server:

```bash
# Example: Change prefix key
set-option -g prefix C-a  # Use Ctrl+A instead of Ctrl+\

# Example: Add custom split bindings
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"
```

### iTerm2 Preferences

Optimize iTerm2 settings:

1. **Preferences → General → Closing**
   - ✓ Check "Confirm 'Quit iTerm2'" to prevent accidental exits

2. **Preferences → Profiles → Terminal**
   - Report Terminal Type: `xterm-256color`

3. **Preferences → Keys**
   - Set up global hotkey to show/hide iTerm2 (optional)

## Troubleshooting

### Control Mode doesn't work

```bash
# Check tmux version (need 1.8+, recommend 2.1+)
ssh devserver 'tmux -V'

# Try updating tmux on remote server
ssh devserver 'sudo apt update && sudo apt install tmux'
```

### Scrolling doesn't feel native

Make sure you're using Control Mode (`tmux -CC`). Regular tmux doesn't provide native scrolling.

```bash
# Wrong: ssh devserver -t 'tmux attach'
# Right:  ssh devserver -t 'tmux -CC attach'
```

### Connection keeps dropping

Verify SSH keepalive settings in `~/.ssh/config`:

```
ServerAliveInterval 60
ServerAliveCountMax 3
```

### ControlMaster issues

```bash
# Check if master connection exists
ssh -O check devserver

# Manually close master connection if stuck
ssh -O exit devserver

# Check permissions
ls -la ~/.ssh/controlmasters/
chmod 700 ~/.ssh/controlmasters
```

### Mouse selection includes pane borders

Toggle tmux pane borders off:

```bash
# In tmux (Ctrl+\ is prefix)
Ctrl+\ :set -g pane-border-status off
```

### Can't copy text from terminal applications

Some applications override terminal selection. Hold Option (⌥) while selecting to bypass tmux mouse mode.

### Performance issues with many windows

Control Mode uses more resources than standard tmux. Each window is a full iTerm2 window (~100-200MB).

Consider:
- Using fewer windows
- Using tmux panes within windows (splits)
- Closing windows you're not actively using

## Advanced: Adding Mosh for Mobile Work

If you work from unreliable networks (cafes, trains, mobile hotspots), add Mosh for better resilience:

**Install Mosh:**

```bash
# On Mac
brew install mosh

# On remote server
sudo apt install mosh
```

**Add alias for mobile work:**

```bash
alias work-mobile='mosh devserver -- tmux attach -t work || tmux new -s work'
```

**Note:** Mosh works great with tmux but doesn't support Control Mode. Use it for mobile scenarios and `work` alias for desktop.

## Quick Reference Card

### Connection Commands
```bash
work              # Connect with Control Mode
work-setup        # Create new session with workflow
work-standard     # Standard tmux (non-Control Mode)
```

### tmux Commands (Prefix: Ctrl+\)
```bash
Ctrl+\ c          # Create new window
Ctrl+\ d          # Detach from session
Ctrl+\ |          # Split pane vertically
Ctrl+\ -          # Split pane horizontally
Ctrl+\ r          # Reload tmux config
Ctrl+o            # Enter copy mode (for searching/scrolling)
```

### Control Mode Shortcuts (Native Mac)
```bash
Cmd+T             # New window
Cmd+D             # Split vertically
Cmd+Shift+D       # Split horizontally
Cmd+W             # Close window
Cmd+Tab           # Switch windows
Cmd+C / Cmd+V     # Copy / Paste
```

### Copy Mode (Emacs-style)
```bash
Ctrl+o            # Enter copy mode
C-Space           # Begin selection (or C-@)
M-w               # Copy selection (to macOS clipboard)
C-w               # Cut selection (to macOS clipboard)
q                 # Exit copy mode
C-s               # Search forward (incremental search)
C-r               # Search backward (reverse incremental search)
C-v               # Page down
M-v               # Page up
```

## Next Steps

1. **Try it out:** Run `work-setup` to create your first session
2. **Customize:** Edit `tmux-work-session.sh` for your specific workflow
3. **Learn tmux:** While Control Mode handles most UI, learning tmux commands helps
4. **Set up multiple servers:** Add more hosts to `~/.ssh/config`
5. **Experiment with layouts:** Try different window/pane arrangements

## Additional Resources

- [iTerm2 tmux Integration Documentation](https://iterm2.com/documentation-tmux-integration.html)
- [tmux Cheat Sheet](https://tmuxcheatsheet.com/)
- [SSH Config Best Practices](https://www.ssh.com/academy/ssh/config)

## Getting Help

If you encounter issues:

1. Check the troubleshooting section above
2. Verify all prerequisites are installed
3. Test SSH connection without tmux: `ssh devserver`
4. Check tmux logs on server: `~/tmux-server-*.log`
5. Review iTerm2 console: Window → tmux Dashboard

Enjoy your optimized remote development workflow!
