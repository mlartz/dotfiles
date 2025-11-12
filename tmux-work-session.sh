#!/usr/bin/env bash
#
# tmux-work-session.sh
# ====================
# Creates or attaches to a tmux work session with 1 emacs + 3 shell windows
#
# Usage:
#   Local:  ./tmux-work-session.sh
#   Remote: ssh devserver -t './dotfiles/tmux-work-session.sh'
#   iTerm2 Control Mode: ssh devserver -t 'tmux -CC attach -t work || ./dotfiles/tmux-work-session.sh'

SESSION_NAME="work"
EMACS_WINDOW="emacs"
SHELL1_WINDOW="shell-1"
SHELL2_WINDOW="shell-2"
SHELL3_WINDOW="shell-3"

# Check if tmux is installed
if ! command -v tmux &> /dev/null; then
    echo "Error: tmux is not installed"
    exit 1
fi

# Check if session already exists
if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    echo "Session '$SESSION_NAME' already exists. Attaching..."
    exec tmux attach-session -t "$SESSION_NAME"
fi

echo "Creating new tmux session: $SESSION_NAME"

# Create new session with first window for emacs
tmux new-session -d -s "$SESSION_NAME" -n "$EMACS_WINDOW"

# Start emacs in the first window (in terminal mode)
# Use 'emacs -nw' for terminal mode, or just 'emacs' if in Control Mode
tmux send-keys -t "$SESSION_NAME:$EMACS_WINDOW" 'emacs -nw' C-m

# Create three additional shell windows
tmux new-window -t "$SESSION_NAME" -n "$SHELL1_WINDOW"
tmux new-window -t "$SESSION_NAME" -n "$SHELL2_WINDOW"
tmux new-window -t "$SESSION_NAME" -n "$SHELL3_WINDOW"

# Optional: Run specific commands in each shell window
# Uncomment and customize these as needed:

# Shell 1: Maybe for git operations
# tmux send-keys -t "$SESSION_NAME:$SHELL1_WINDOW" 'cd ~/projects' C-m

# Shell 2: Maybe for running servers
# tmux send-keys -t "$SESSION_NAME:$SHELL2_WINDOW" 'cd ~/projects' C-m

# Shell 3: Maybe for general commands
# tmux send-keys -t "$SESSION_NAME:$SHELL3_WINDOW" 'cd ~/projects' C-m

# Select the emacs window by default
tmux select-window -t "$SESSION_NAME:$EMACS_WINDOW"

echo "Session '$SESSION_NAME' created successfully!"
echo ""
echo "Windows created:"
echo "  0: $EMACS_WINDOW  - Running emacs"
echo "  1: $SHELL1_WINDOW - Available shell"
echo "  2: $SHELL2_WINDOW - Available shell"
echo "  3: $SHELL3_WINDOW - Available shell"
echo ""
echo "Attaching to session..."

# Attach to the session
exec tmux attach-session -t "$SESSION_NAME"
