export PATH=$HOME/bin:/usr/local/bin:$HOME/.local/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"
HYPHEN_INSENSITIVE="true"
DISABLE_MAGIC_FUNCTIONS="true"
COMPLETION_WAITING_DOTS="true"

plugins=(
  git
  zsh-autosuggestions
  fast-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

########### EXPORTS ##########
export HISTSIZE=10000
export SAVEHIST=10000
export EDITOR="nvim"
export VISUAL="nvim"
export KUBE_EDITOR="nvim"

########### FZF Exports ##############
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# CTRL-T to preview files
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'bat {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# CTRL-/ to toggle small preview window to see the full command
# CTRL-Y to copy the command into clipboard using pbcopy
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"

# Print tree structure in the preview window
export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'tree -C {}'"

# Use kubectl with fzf
command -v fzf >/dev/null 2>&1 && { 
	source <(kubectl completion zsh | sed 's#${requestComp} 2>/dev/null#${requestComp} 2>/dev/null | head -n -1 | fzf  --multi=0 #g')
}

compdef kubecolor=kubectl

########### ALIASES ##########
alias cat = "bat"

# Eza - ls alternative
alias ls="eza --icons --group-directories-first"
alias ll="eza --icons --group-directories-first -lhgb --no-time"
alias la="eza --icons --group-directories-first -lhgba --no-time"
alias lt="eza --icons --group-directories-first --tree --level=2"

# Vim/Neovim
alias v="nvim"
alias vim="nvim"

# Git
alias ga="git add"
alias gc="git commit"
alias gco="git checkout"
alias gst="git status"
alias gd="git diff"
alias gdc="git diff --cached"
alias gl="git -P log --oneline -n 20"
alias gll="git -P log --graph --oneline --all -n 20"
alias gpl="git pull"
alias gps="git push"
alias gsu="git submodule update --init --recursive"
alias gb="git branch"
alias gba="git branch -a"

# Other apps
alias lg="lazygit" # lazygit
lzg () {
    export LAZYGIT_NEW_DIR_FILE=~/.lazygit/newdir

    lazygit "$@"

    if [ -f "$LAZYGIT_NEW_DIR_FILE" ]; then
        cd "$(cat "$LAZYGIT_NEW_DIR_FILE")"
        rm -f "$LAZYGIT_NEW_DIR_FILE" > /dev/null
    fi
}

alias lzd='lazydocker' # lazydocker
alias r="ranger" # file manager

# Kubernetes
alias kdebug="kubectl run tmp-shell --rm -i --tty --image nicolaka/netshoot"
## Check if kubecolor is installed
if which kubecolor >/dev/null 2>&1;then
    alias k="kubecolor"
else
  alias k="kubectl"
fi
alias k8s-show-ns=" kubectl api-resources --verbs=list --namespaced -o name  | xargs -n 1 kubectl get --show-kind --ignore-not-found  -n"


# Tmux
alias tn="tmux new -s"
alias ta="tmux a -t"
alias tk="tmux kill-session -t"
alias tl="tmux list-sessions"

# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias ~="cd ~"

# Utilities
alias h="history"
alias c="clear"
alias reload="source ~/.zshrc"
alias zshconfig="nvim ~/.zshrc"
alias -g NE='2>/dev/null' # Redirect stderr to /dev/null with -> NE
alias -g NO='>/dev/null' # Redirect stdout to /dev/null -> NO
alias -g NUL='>/dev/null 2>&1' # Redirect both stdout and stderr to /dev/null -> NUL
alias -g J='| jq' # Pipe to jq
alias -g C='| pbcopy' # Copy output to clipboard (macOS) (use xclip for other OS)

# Safety nets
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"

# Grep with color
alias grep="grep --color=auto"
alias egrep="egrep --color=auto"
alias fgrep="fgrep --color=auto"


########### Shell Options ##########
# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Better completion menu
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# History options
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt SHARE_HISTORY
setopt APPEND_HISTORY

########### FUNCTIONS ##########
# Create directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract various archive formats
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Find file by name
ff() {
    find . -type f -iname "*$1*"
}

# Find directory by name
fd() {
    find . -type d -iname "*$1*"
}

########### Some ZSH cool stuff/widgets ##########
## Kindly borrowed from @elliottminns's github

# -------------------------------------------
# Edit Command Buffer
# -------------------------------------------
# Open the current command in your $EDITOR (e.g., neovim)
# Press Ctrl+X followed by Ctrl+E to trigger
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# -------------------------------------------
# Undo in ZSH
# -------------------------------------------
# Press Ctrl+_ (Ctrl+Underscore) to undo
# This is built-in, no configuration needed!
# Redo widget:
bindkey '^Y' redo

# -------------------------------------------
# Magic Space - Expand History
# -------------------------------------------
# Expands history expressions like !! or !$ when you press space
bindkey ' ' magic-space

# -------------------------------------------
# chpwd Hook - Run Commands on Directory Change
# -------------------------------------------
autoload -Uz add-zsh-hook

# To add a hook use add-zsh-hook <hook> <function to execute>
# E.g. add-zsh-hook chpwd foo

# -------------------------------------------
# Custom Widgets
# -------------------------------------------

# Clear screen but keep current command buffer
# Ctrl-X + l
function clear-screen-and-scrollback() {
  echoti civis >"$TTY"
  printf '%b' '\e[H\e[2J\e[3J' >"$TTY"
  echoti cnorm >"$TTY"
  zle redisplay
}
zle -N clear-screen-and-scrollback
bindkey '^Xl' clear-screen-and-scrollback

# Copy current command buffer to clipboard (macOS) (use xclip for other OS)
# Ctrl-X + c
function copy-buffer-to-clipboard() {
  echo -n "$BUFFER" | pbcopy
  zle -M "Copied to clipboard"
}
zle -N copy-buffer-to-clipboard
bindkey '^Xc' copy-buffer-to-clipboard

########### EXPORTS #########
autoload -U compinit; compinit
# Starship
eval "$(starship init zsh)"
