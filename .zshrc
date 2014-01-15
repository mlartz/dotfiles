ZSH=$HOME/.oh-my-zsh
MYZSH=$HOME/.zsh

# CASE_SENSITIVE="true"
# DISABLE_AUTO_UPDATE="true"
# export UPDATE_ZSH_DAYS=13
# DISABLE_LS_COLORS="true"
# DISABLE_AUTO_TITLE="true"
COMPLETION_WAITING_DOTS="true"
SOLARIZED_THEME="dark"

plugins=(brew bundler gem git node npm rails rake ruby rvm virtualenv virtualenvwrapper)

source $ZSH/oh-my-zsh.sh
source $HOME/.config/mlartz.zsh-theme

source $MYZSH/aliases

source /usr/local/bin/virtualenvwrapper.sh

setopt nocorrectall

export PATH=$HOME/local/bin:/usr/local/sbin:/usr/local/bin:$PATH:$HOME/.rvm/bin
export CLICOLOR=1
