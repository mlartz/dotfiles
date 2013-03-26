ZSH=$HOME/.oh-my-zsh

# CASE_SENSITIVE="true"
# DISABLE_AUTO_UPDATE="true"
# export UPDATE_ZSH_DAYS=13
# DISABLE_LS_COLORS="true"
# DISABLE_AUTO_TITLE="true"
COMPLETION_WAITING_DOTS="true"
SOLARIZED_THEME="dark"

plugins=(brew bundler gem git rails rake ruby rvm bundler)

source $ZSH/oh-my-zsh.sh
source $HOME/.config/mlartz.zsh-theme

setopt nocorrectall

export PATH=/usr/local/bin:$PATH:$HOME/.rvm/bin
export CLICOLOR=1
