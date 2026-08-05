#!/usr/bin/env zsh

sessions=$(tmux list-sessions -F '#{session_name}' 2>/dev/null)

list_cmd="fd --hidden --type d --glob .git $HOME/Moller/ $HOME/.dotfiles 2>/dev/null |
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

project_dir=$(eval "$list_cmd" |
fzf --ansi \
    --border=rounded \
    --border-label=" Projects " \
    --border-label-pos=3 \
    --input-border \
    --prompt=" " \
    --pointer="▶" \
    --header=$'  enter: tmux │ ctrl-x: kill session\n' \
    --preview-window=right:55%:border-left \
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

[[ -z "$project_dir" ]] && exit 0

project_dir=$(echo "$project_dir" | sed 's|^[● ] *||')
project_dir="${project_dir/#\~/$HOME}"

session_name=$(basename "$project_dir" | sed 's/^\.//')

tmux new-session -d -s "$session_name" -c "$project_dir" 2>/dev/null
tmux switch-client -t "$session_name"
