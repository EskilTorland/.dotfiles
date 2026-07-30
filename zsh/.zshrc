# Load p10k instant prompt if available
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export AIDER_DARK_MODE=true

unsetopt CORRECT_ALL
unsetopt CORRECT

# Homebrew (not in .zshenv since it's macOS-interactive only)
if [ -d "/opt/homebrew/bin" ]; then
    export PATH=/opt/homebrew/bin:$PATH
fi

# Oh My Zsh configuration
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
ZSH_DISABLE_COMPFIX=true
plugins=(git zsh-syntax-highlighting zsh-autosuggestions zsh-completions)

export LANG=en_US@UTF-8

source $ZSH/oh-my-zsh.sh

# Aliases for vim and vi
alias vim="nvim"
alias vi="nvim"
alias tf="terraform"
alias bbp="cd ~/Moller/bruktbilportalen"
alias bb="cd ~/Moller/bruktbilsalg"
ghd() {
    gh pr diff "$@" | delta
}

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
#export BAT_THEME="gruvbox-dark"
export BAT_THEME="kanagawa-dragon"

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

 function projects() {                                                                                                                       
     local project_dir                                                                                                                       
     project_dir=$(fd --hidden --type d --glob .git ~/Moller/ ~/.dotfiles 2>/dev/null |                                                                  
         sed 's|/\.git/*$||' |                                                                                                               
         fzf --preview '                                                                                                                     
             echo -e "\033[1;36m# Project: \033[1;33m$(basename {})\033[0m"                                                                  
             echo -e "\033[1;36m=====================\033[0m"                                                                                
                                                                                                                                             
             echo -e "\n\033[1;36m# Directory Structure:\033[0m"                                                                             
             echo -e "\033[1;36m====================\033[0m"                                                                                 
             eza --tree --color=always --level=1 {}                                                                                          
                                                                                                                                             
             echo -e "\n\033[1;36m# Git Status:\033[0m"                                                                                      
             echo -e "\033[1;36m============\033[0m"                                                                                         
             git -C {} status -s                                                                                                             
                                                                                                                                             
             echo -e "\n\033[1;36m# Current Branch:\033[0m"                                                                                  
             echo -e "\033[1;36m===============\033[0m"                                                                                      
             git -C {} branch')                                                                                                              
                                                                                                                                             
         if [ -n "$project_dir" ]; then                                                                  
                                                                                                     
         if read -q 'choice?Create/attach tmux session? (y/n): '; then                               
             echo # Add a newline after the response                                                 
             local session_name=$(basename "$project_dir")                                           
             # Check if we're already in a tmux session                                              
             if [ -n "$TMUX" ]; then                                                                 
                 # We're in a tmux session, create a new one                                         
                tmux new -d -s "$session_name" -c "$project_dir" 2>/dev/null                                  
                tmux switch-client -t "$session_name"                                           
             else                                                                                    
                tmux new-session -A -s "$session_name" -c "$project_dir"
             fi                                                                                      
         else 
             cd "$project_dir"
         fi                                                                                          
     fi                                                                                              
 }  

bindkey -s 'π' 'projects\n'

# Initialize zoxide (cached for fast startup — regenerate with: zoxide init --cmd cd zsh > ~/.zoxide.zsh)
source ~/.zoxide.zsh

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

# NVM (lazy-loaded for fast startup)
export NVM_DIR="$HOME/.nvm"
nvm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  nvm "$@"
}
node() { unset -f nvm node npm npx; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"; node "$@"; }
npm() { unset -f nvm node npm npx; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"; npm "$@"; }
npx() { unset -f nvm node npm npx; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"; npx "$@"; }

DOTFILES_DIR="$HOME/.dotfiles"  
if [ -f "$DOTFILES_DIR/.env" ]; then
    source "$DOTFILES_DIR/.env"
fi
export ASPNETCORE_ENVIRONMENT=Development

export GITHUB_TOKEN=$(gh auth token)

export FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT=true

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/eskil/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

alias glog="git log --oneline --graph --decorate --all"

# To customize prompt, run `p10k configure` or edit ~/.dotfiles/zsh/.p10k.zsh.
[[ ! -f ~/.dotfiles/zsh/.p10k.zsh ]] || source ~/.dotfiles/zsh/.p10k.zsh
