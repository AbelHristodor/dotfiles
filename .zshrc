# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Themes
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

# Oh-My-Zsh
source $ZSH/oh-my-zsh.sh

# Starship
eval "$(starship init zsh)"

## ---- Aliases ----
#
# Kukectl
alias kubectl="kubecolor"
alias k="kubectl"

# Vim
alias v="nvim"

# Ls - alternative
alias ls="exa --icons --group-directories-first"
alias ll="exa --icons --group-directories-first -lhgb --no-time "

# Git
# Deletes all branches not on remote
alias gd="git branch --merged | xargs git branch -d"
alias ga="git add"
alias gc="git commit"
alias gp="git push"

# Battery level
alias bat="cat /sys/class/power_supply/BAT1/capacity"


