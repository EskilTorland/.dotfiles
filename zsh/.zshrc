# Load p10k instant prompt if available
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Oh My Zsh configuration
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git zsh-syntax-highlighting zsh-autosuggestions zsh-completions)

autoload -U compinit && compinit

export LANG=en_US@UTF-8

source $ZSH/oh-my-zsh.sh

# Aliases for vim and vi
alias vim="nvim"
alias vi="nvim"
alias tf="terraform"

export VISUAL=nvim
export EDITOR="$VISUAL"

# Powerlevel10k theme configuration
source ~/powerlevel10k/powerlevel10k.zsh-theme 
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# fzf configuration
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

export FZF_DEFAULT_COMMAND='fd --hidden --strip-cwd-prefix --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type=d --hidden --strip-cwd-prefix --exclude .git'

_fzf_compgen_path() {
  fd --hidden --follow --exclude .git . "$1"
}

_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude .git . "$1"
}

# Load fzf-git script
source ~/fzf-git.sh/fzf-git.sh

_fzf_git_fzf() {
  fzf --ansi --preview 'git diff --color=always {} | delta'
}

# Bat configuration
export BAT_THEME="gruvbox-dark"

# Eza (better ls) configuration
alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"

# fzf preview options
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo $'{}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "bat -n --color=always --line-range :500 {}" "$@" ;;
  esac
}

# Initialize zoxide
eval "$(zoxide init --cmd cd zsh)"

# History configuration
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

export PATH="$PATH:./node_modules/.bin"

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8


### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/eskil/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
