export PATH=$HOME/bin:/usr/local/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"
HYPHEN_INSENSITIVE="true"
DISABLE_MAGIC_FUNCTIONS="true"
COMPLETION_WAITING_DOTS="true"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  docker-zsh-completion
  poetry-env
  poetry
)

source $ZSH/oh-my-zsh.sh

# Autocorrect commands 
eval $(thefuck --alias fu)

# Starship
eval "$(starship init zsh)"

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Local bin
export PATH="/home/norte/.local/bin:$PATH"

# Start tmux -- Install TPM first!!
# if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
#   exec tmux
# fi

########### ALIASES ##########

# Exa - ls alternative
alias ls="exa --icons --group-directories-first"
alias ll="exa --icons --group-directories-first -lhgb --no-time"

# Vim
alias v="nvim"

# Kubectl or Kubecolor
alias k="kubectl"
alias ktx="kubectl ctx"
alias kns="kubectl ns"
alias kpop="popeye"
alias stern="kubectl stern"

## Check if kubecolor is installed
if which kubecolor >/dev/null 2&>1;then
    alias k="kubecolor"
fi

# Git
alias ga="git add"
alias gc="git commit"
alias gp="git push"

# Tmux
alias tn="tmux new -s"
alias ta="tmux a -t"
alias tk="tmux kill-session -t"

# Lazygit
alias lg="lazygit"
lzg () {
    export LAZYGIT_NEW_DIR_FILE=~/.lazygit/newdir

    lazygit "$@"

    if [ -f "$LAZYGIT_NEW_DIR_FILE" ]; then
        cd "$(cat "$LAZYGIT_NEW_DIR_FILE")"
        rm -f "$LAZYGIT_NEW_DIR_FILE" > /dev/null
    fi
}
########### EXPORTS #########
#
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/norte/google-cloud-sdk/path.bash.inc' ]; then . '/home/norte/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/norte/google-cloud-sdk/completion.bash.inc' ]; then . '/home/norte/google-cloud-sdk/completion.bash.inc'; fi
export PATH=$PATH:/home/norte/.spicetify
. "$HOME/.cargo/env"

# krew path
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
