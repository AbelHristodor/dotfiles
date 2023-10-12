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

########### ALIASES ##########

# Exa - ls alternative
alias ls="exa --icons --group-directories-first"
alias ll="exa --icons --group-directories-first -lhgb --no-time"

# Vim
alias v="nvim"

# Git
alias ga="git add"
alias gc="git commit"
alias gp="git push"


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
