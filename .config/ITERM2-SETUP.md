# iTerm2 Configuration Guide

Complete guide for iTerm2 setup with Gruvbox Dark theme, optimized for SSH and tmux workflows.

## Installing the Gruvbox Dark Color Scheme

### Manual Installation

To use the Gruvbox Dark color scheme with your iTerm2 profile:

1. **Import the color scheme:**
   ```bash
   open ~/.config/Gruvbox-Dark.itermcolors
   ```
   This will automatically import the color scheme into iTerm2.

2. **Apply to your profile:**
   - Open iTerm2 Preferences (⌘+,)
   - Go to **Profiles** → **Colors**
   - Click the **Color Presets...** dropdown in the bottom right
   - Select **Gruvbox Dark** from the list

3. **Set as default (optional):**
   - In the Profiles pane, select your profile
   - Click **Other Actions...** → **Set as Default**

## Gruvbox Dark Color Scheme

### Color Palette

The Gruvbox Dark theme provides excellent readability with warm, retro colors:

- **Background:** `#282828` (dark gray)
- **Foreground:** `#ebdbb2` (light cream)
- **Black:** `#282828` / Bright: `#928374`
- **Red:** `#cc241d` / Bright: `#fb4934`
- **Green:** `#98971a` / Bright: `#b8bb26`
- **Yellow:** `#d79921` / Bright: `#fabd2f`
- **Blue:** `#458588` / Bright: `#83a598`
- **Magenta:** `#b16286` / Bright: `#d3869b`
- **Cyan:** `#689d6a` / Bright: `#8ec07c`
- **White:** `#a89984` / Bright: `#ebdbb2`

### Benefits

- **Low Eye Strain:** Warm colors reduce eye fatigue during long sessions
- **Good Contrast:** Excellent readability without being harsh
- **Syntax Highlighting:** Works beautifully with vim, emacs, and other editors
- **SSH-Friendly:** Colors remain distinguishable even over compressed connections

## SSH and Tmux Best Practices

### Configuration Highlights

The included iTerm2 profile is specifically optimized for remote work:

#### 1. Terminal Compatibility

```bash
# Terminal type
TERM=xterm-256color
```

**Why:** Best compatibility with remote Linux servers. Most servers recognize xterm-256color and enable full color support.

#### 2. Scrollback Buffer

- **Local work:** 10,000 lines (configurable in profile)
- **Remote tmux:** Unlimited scrollback in tmux itself (configured in `.tmux.conf`)

**Why:** Large local buffer for quick lookups, but tmux handles long-term scrollback on remote servers.

#### 3. Mouse Support

Enabled in both iTerm2 and tmux (`.tmux.conf`):

```tmux
set -g mouse on
```

**Benefits:**
- Click to select panes
- Scroll through output
- Resize panes by dragging
- Copy text without keyboard commands

#### 4. Clipboard Integration

iTerm2 clipboard access is enabled, allowing:

```bash
# On remote server, copy to local clipboard
echo "hello" | pbcopy  # Works via SSH if properly configured

# Or use tmux copy mode with mouse selection
# Selection automatically copies to clipboard
```

#### 5. Tmux Integration Mode

iTerm2's tmux integration (`tmux -CC`) provides:

- Native macOS windows for tmux panes
- Tab bar shows tmux windows
- Seamless local/remote experience
- Survives SSH disconnections

**Usage:**
```bash
# Connect to remote server and attach with integration
ssh user@remote
tmux -CC attach

# Or start new session with integration
tmux -CC new-session -s work
```

### Performance Optimizations

#### GPU Acceleration

```bash
GPU Rendering: Enabled
Metal Renderer: Enabled
```

**Why:** Dramatically improves rendering performance, especially important for:
- Large scrollback buffers
- High-frequency updates (tail -f, htop, etc.)
- Split panes in tmux
- Syntax highlighting in vim/emacs

#### Efficient Paste

```bash
Paste Chunk Size: 1024 bytes
Paste Chunk Delay: 0.01 seconds
```

**Why:** Prevents overwhelming remote shells with large pastes, avoiding:
- Dropped characters
- Command truncation
- Shell buffer overflow

### Keyboard Shortcuts

#### Option Key Behavior

The profile configures Option keys as **Normal** (not Meta):

**Benefits:**
- Option+Arrow moves by word in bash/zsh
- Option+Delete deletes word
- Standard macOS keyboard behavior

**For Emacs users:** If you need Meta key, change in:
- Preferences → Profiles → Keys → Left/Right Option Key

#### Key Bindings

Standard macOS bindings work:
- `⌘+T` - New tab
- `⌘+D` - Split vertically
- `⌘+Shift+D` - Split horizontally
- `⌘+[` / `⌘+]` - Navigate splits
- `⌘+K` - Clear buffer
- `⌘+F` - Find

### Session Management

#### Auto-Close Behavior

```bash
Close Sessions On End: Yes
Prompt Before Closing: If jobs running
```

**Smart job detection** ignores: ssh, tmux, telnet

**Why:**
- Automatically closes finished sessions
- Warns before closing active work
- Doesn't warn when you're "just" in SSH or tmux (expected behavior)

#### Window Restoration

```bash
Restore Windows: Disabled
```

**Why:** SSH sessions from previous runs are usually stale. Better to start fresh.

## Working with Remote Servers

### Same Dotfiles Everywhere

The `.tmux.conf` in this repo works identically on:
- macOS (local iTerm2)
- Linux servers (over SSH)
- Docker containers
- WSL (if needed)

**Setup on remote server:**
```bash
# Clone dotfiles on remote server
git clone https://github.com/mlartz/dotfiles.git ~/dotfiles

# Symlink tmux config
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf

# Also symlink shell config
ln -sf ~/dotfiles/.zshrc ~/.zshrc
```

### SSH Config Recommendations

Add to `~/.ssh/config`:

```ssh
# Keep connections alive
Host *
    ServerAliveInterval 60
    ServerAliveCountMax 3

# Reuse connections (faster)
    ControlMaster auto
    ControlPath ~/.ssh/sockets/%r@%h:%p
    ControlPersist 600

# Enable compression (good for slow connections)
    Compression yes

# Forward SSH agent (for git on remote)
    ForwardAgent yes
```

Create socket directory:
```bash
mkdir -p ~/.ssh/sockets
```

### Tmux Workflow Examples

#### Local Development

```bash
# Start tmux locally
tmux new -s dev

# Split into panes
# Ctrl+\ | (vertical split)
# Ctrl+\ - (horizontal split)

# Navigate panes with mouse or:
# Ctrl+\ + arrow keys
```

#### Remote Server Work

```bash
# SSH to server
ssh production-server

# Attach to existing session or create new one
tmux attach -t work || tmux new -s work

# Detach when done (session keeps running)
# Press: Ctrl+\ then d
```

#### iTerm2 Tmux Integration

```bash
# SSH and use native integration
ssh remote-server
tmux -CC attach -t work || tmux -CC new -s work

# Now tmux windows appear as native iTerm2 tabs/windows!
# Each pane is a real macOS window
# Survives SSH disconnections
```

## Font Configuration

### Recommended Fonts

All these fonts are installed via the Brewfile:

1. **Fira Code** (default in profile)
   - Excellent ligatures
   - Great for programming
   - Clear at small sizes

2. **JetBrains Mono**
   - Designed for developers
   - Excellent readability
   - Good ligature support

3. **Source Code Pro**
   - Clean and professional
   - No ligatures (if you prefer)
   - Excellent hinting

### Change Font

1. Open Preferences → Profiles → Text
2. Click "Change Font" under "Font"
3. Select your preferred font and size
4. Recommended size: 12-14pt for retina displays

### Enable Ligatures

Ligatures are enabled by default for:
- `==` `!=` `<=` `>=`
- `->` `=>` `|>`
- `&&` `||`

To disable:
- Preferences → Profiles → Text
- Uncheck "Use ligatures"

## Troubleshooting

### Colors Look Wrong Over SSH

**Problem:** Colors appear different on remote server

**Solutions:**
1. Check TERM variable:
   ```bash
   echo $TERM
   # Should be: xterm-256color
   ```

2. Force TERM in SSH:
   ```bash
   ssh -o "SetEnv TERM=xterm-256color" user@host
   ```

3. Or add to `~/.ssh/config`:
   ```ssh
   Host *
       SetEnv TERM=xterm-256color
   ```

### Tmux Colors Don't Match

**Problem:** Tmux shows different colors than shell

**Solution:** The `.tmux.conf` includes:
```tmux
set -g default-terminal "screen-256color"
```

This is correct! Tmux uses `screen-256color` internally, while iTerm2 uses `xterm-256color`.

### Mouse Doesn't Work in Tmux

**Problem:** Can't click panes or scroll with mouse

**Solutions:**
1. Check tmux version:
   ```bash
   tmux -V
   # Need 2.1+ for unified mouse support
   ```

2. Verify mouse is enabled in `.tmux.conf`:
   ```tmux
   set -g mouse on
   ```

3. Reload tmux config:
   ```bash
   tmux source-file ~/.tmux.conf
   ```

### Tmux Integration Not Working

**Problem:** `tmux -CC` doesn't show native windows

**Solutions:**
1. Verify tmux integration is enabled:
   - Preferences → General → tmux → "Use tmux integration"

2. Make sure you're using `-CC` flag:
   ```bash
   tmux -CC attach
   ```

3. Check tmux version compatibility (need 1.8+)

### Slow Performance Over SSH

**Solutions:**

1. Enable compression in SSH config:
   ```ssh
   Host slow-connection
       Compression yes
       CompressionLevel 6
   ```

2. Reduce scrollback in iTerm2:
   - Preferences → Profiles → Terminal
   - Set scrollback lines to 1000 (instead of 10000)

3. Disable GPU rendering if over very slow connection:
   - Preferences → General → GPU Rendering (uncheck)

### Copy/Paste Not Working

**Problem:** Can't paste into remote server

**Solutions:**
1. Check clipboard access:
   - Preferences → General → Selection
   - Enable "Applications in terminal may access clipboard"

2. For large pastes, the chunk settings prevent issues

3. In tmux, use native copy mode:
   - `Ctrl+\` then `[` to enter copy mode
   - Mouse select, or use vim keys
   - Text auto-copies to clipboard

## Advanced Customization

### Creating Your Own Profile

1. Duplicate Gruvbox Dark profile:
   - Preferences → Profiles
   - Select "Gruvbox Dark"
   - Click "+" and choose "Duplicate Profile"

2. Customize colors:
   - Go to Colors tab
   - Click on any color to change it

3. Export for backup:
   - Profiles → Other Actions → Save Profile as JSON

### Multiple Profiles for Different Servers

Create profiles for different environments:

```json
{
  "Profiles": [
    {
      "Name": "Production",
      "Badge Text": "PROD",
      "Badge Color": { "Red": 1, "Green": 0, "Blue": 0 }
    },
    {
      "Name": "Development",
      "Badge Text": "DEV",
      "Badge Color": { "Red": 0, "Green": 1, "Blue": 0 }
    }
  ]
}
```

### Custom Key Bindings

Add custom key bindings in Preferences → Keys:

Example: Alt+Left/Right for word navigation
- Action: "Send Escape Sequence"
- Esc+: `b` (backward) or `f` (forward)

## Resources

### Documentation
- [iTerm2 Official Docs](https://iterm2.com/documentation.html)
- [Tmux Manual](https://man.openbsd.org/tmux.1)
- [Gruvbox Theme](https://github.com/morhetz/gruvbox)

### Related Files
- `.tmux.conf` - Tmux configuration (works on all platforms)
- `.macos` - Automated iTerm2 setup script
- `Gruvbox-Dark.itermcolors` - Color scheme file

### Tips & Tricks
- Use `Cmd+Shift+H` to show paste history
- `Cmd+Option+B` shows recent commands
- `Cmd+;` shows autocomplete
- Double-click selects word, triple-click selects line
- Hold `Option` while selecting to make rectangular selection
