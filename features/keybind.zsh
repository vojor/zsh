typeset -g -A key
key=(
    Home      "${terminfo[khome]}"
    End       "${terminfo[kend]}"
    Insert    "${terminfo[kich1]}"
    Delete    "${terminfo[kdch1]}"
    Up        "${terminfo[kcuu1]}"
    Down      "${terminfo[kcud1]}"
    Left      "${terminfo[kcub1]}"
    Right     "${terminfo[kcuf1]}"
    Backspace "${terminfo[kbs]}"
    Tab       "${terminfo[ht]:-$'\t'}"
)

# 基础功能键绑定
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"      beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"       end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"    overwrite-mode
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"    delete-char
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}" backward-delete-char

# Ctrl + 左右键 (单词间跳转)
bindkey '^[[1;5C' forward-word       # Ctrl + Right
bindkey '^[[1;5D' backward-word      # Ctrl + Left

if (( $+widgets[history-substring-search-up] )); then
    [[ -n "${key[Up]}"   ]] && bindkey -- "${key[Up]}"   history-substring-search-up
    [[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" history-substring-search-down
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down

    HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=magenta,fg=white,bold'
    HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=red,fg=white,bold'
else
    autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
    zle -N up-line-or-beginning-search
    zle -N down-line-or-beginning-search

    [[ -n "${key[Up]}"   ]] && bindkey -- "${key[Up]}"   up-line-or-beginning-search
    [[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search
    bindkey '^[[A' up-line-or-beginning-search
    bindkey '^[[B' down-line-or-beginning-search
fi
