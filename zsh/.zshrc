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

# Cache compinit dump for fast startup (rebuilds only when stale)
export ZSH_COMPDUMP="${HOME}/.cache/zsh/.zcompdump-${ZSH_VERSION}"
[[ -d "${HOME}/.cache/zsh" ]] || mkdir -p "${HOME}/.cache/zsh"

plugins=(git zsh-syntax-highlighting zsh-autosuggestions)

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
source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme
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
export BAT_THEME="kanagawa"
# export BAT_THEME="Catppuccin Mocha"

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
      local result key project_dir

      # Get active tmux sessions for marking
      local sessions=$(tmux list-sessions -F '#{session_name}' 2>/dev/null)

      # Helper script for generating the project list (used by fzf reload)
      local list_cmd="fd --hidden --type d --glob .git $HOME/Moller/ $HOME/.dotfiles 2>/dev/null |
          sed 's|/\.git/*\$||' |
          sort |
          while read -r d; do
            name=\$(basename \"\$d\" | sed 's/^\.//')
            short=\$(echo \"\$d\" | sed \"s|$HOME|~|\")
            if tmux list-sessions -F '#{session_name}' 2>/dev/null | grep -qx \"\$name\"; then
              echo \"\033[38;5;107m●\033[0m \$short\"
            else
              echo \"  \$short\"
            fi
          done"

      result=$(eval "$list_cmd" |
      fzf --ansi \
          --border=rounded \
          --border-label=" Projects " \
          --border-label-pos=3 \
          --input-border \
          --prompt=" " \
          --pointer="▶" \
          --header=$'  enter: tmux │ ctrl-e: cd │ ctrl-v: nvim │ ctrl-x: kill session\n' \
          --preview-window=right:55%:border-left \
          --expect=ctrl-e,ctrl-v \
          --color='border:109,pointer:222,prompt:110,header:243,hl:114,hl+:114,info:243,marker:107,fg+:222,bg+:237' \
          --bind="ctrl-x:execute-silent(tmux kill-session -t \$(basename \$(echo {} | sed 's|^[● ] *||' | sed 's|~|$HOME|') | sed 's/^\\.//') 2>/dev/null)+reload($list_cmd)" \
          --preview '
              dir=$(echo {} | sed "s|^[● ] *||" | sed "s|~|'"$HOME"'|")
              echo ""
              echo -e "  \033[38;5;222m $(basename $dir)\033[0m"
              echo -e "  \033[38;5;243m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
              echo ""

              branch=$(git -C $dir branch --show-current 2>/dev/null)
              dirty=$(git -C $dir status --porcelain 2>/dev/null | wc -l | tr -d " ")
              ahead=$(git -C $dir rev-list @{upstream}..HEAD --count 2>/dev/null)
              behind=$(git -C $dir rev-list HEAD..@{upstream} --count 2>/dev/null)

              status_line="  \033[38;5;110m $branch\033[0m"
              if [ "$dirty" -eq 0 ]; then
                status_line="$status_line  \033[38;5;107m✓ clean\033[0m"
              else
                status_line="$status_line  \033[38;5;209m $dirty changed\033[0m"
              fi
              if [ -n "$ahead" ] && [ "$ahead" -gt 0 ]; then
                status_line="$status_line  \033[38;5;110m↑$ahead\033[0m"
              fi
              if [ -n "$behind" ] && [ "$behind" -gt 0 ]; then
                status_line="$status_line  \033[38;5;209m↓$behind\033[0m"
              fi
              echo -e "$status_line"

              echo ""
              echo -e "  \033[38;5;187m Files\033[0m"
              echo -e "  \033[38;5;243m┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈\033[0m"
              eza --tree --color=always --level=1 --icons=always $dir | sed "s/^/  /"

              echo ""
              echo -e "  \033[38;5;187m Recent\033[0m"
              echo -e "  \033[38;5;243m┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈\033[0m"
              git -C $dir log --oneline --color=always -5 --format="  %C(blue)%h%C(reset) %s %C(dim)(%cr)%C(reset)" 2>/dev/null
      ')

      # Parse fzf output: first line is the key pressed, second is the selection
      key=$(echo "$result" | head -1)
      project_dir=$(echo "$result" | tail -1 | sed 's|^[● ] *||')

      # Expand ~ back to full path
      project_dir="${project_dir/#\~/$HOME}"

      if [ -n "$project_dir" ]; then
          local session_name=$(basename "$project_dir" | sed 's/^\.//')

          case "$key" in
              ctrl-e)
                  cd "$project_dir"
                  ;;
              ctrl-v)
                  cd "$project_dir" && $EDITOR .
                  ;;
              *)
                  if [ -n "$TMUX" ]; then
                      tmux new -d -s "$session_name" -c "$project_dir" 2>/dev/null
                      tmux switch-client -t "$session_name"
                  else
                      tmux new-session -A -s "$session_name" -c "$project_dir"
                  fi
                  ;;
          esac
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
alias compfix="rm -f ~/.cache/zsh/.zcompdump-* && exec zsh"

# To customize prompt, run `p10k configure` or edit ~/.dotfiles/zsh/.p10k.zsh.
[[ ! -f ~/.dotfiles/zsh/.p10k.zsh ]] || source ~/.dotfiles/zsh/.p10k.zsh
