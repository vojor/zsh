typeset -g -A key

key=(
    Home      "${terminfo[khome]:-^[[H}"
    End       "${terminfo[kend]:-^[[F}"
    Insert    "${terminfo[kich1]:-^[[2~}"
    Delete    "${terminfo[kdch1]:-^[[3~}"
    Up        "${terminfo[kcuu1]:-^[[A}"
    Down      "${terminfo[kcud1]:-^[[B}"
    Left      "${terminfo[kcub1]:-^[[D}"
    Right     "${terminfo[kcuf1]:-^[[C}"
    Backspace "${terminfo[kbs]:-^?}"
    Tab       "${terminfo[ht]:-$'\t'}"
)

_safe_bind() {
    local widget="$1"
    shift
    for seq in "$@"; do
        [[ -n "$seq" ]] && bindkey -- "$seq" "$widget"
    done
}

_safe_bind beginning-of-line     "${key[Home]}" "^A"
_safe_bind end-of-line           "${key[End]}" "^E"
_safe_bind toggle-overwrite      "${key[Insert]}"
_safe_bind delete-char           "${key[Delete]}"
_safe_bind backward-delete-char  "${key[Backspace]}" "^?" "^H"
_safe_bind clear-screen          "^L"

# 单词跳转
_safe_bind forward-word  '^[[1;5C' '^[[5C' '^[[1;3C' '^[f'
_safe_bind backward-word '^[[1;5D' '^[[5D' '^[[1;3D' '^[b'

# 单词删除
_safe_bind kill-word              '^[d' '^[[3;5~'
_safe_bind backward-kill-word     '^W'

typeset -g HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS='i'
typeset -g HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='fg=magenta,bold'
typeset -g HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='fg=red,bold'

if (( $+widgets[history-substring-search-up] )); then
    _safe_bind history-substring-search-up   "${key[Up]}"   '^[[A' '^P'
    _safe_bind history-substring-search-down "${key[Down]}" '^[[B' '^N'
else
    autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
    zle -N up-line-or-beginning-search
    zle -N down-line-or-beginning-search
    _safe_bind up-line-or-beginning-search   "${key[Up]}"   '^[[A' '^P'
    _safe_bind down-line-or-beginning-search "${key[Down]}" '^[[B' '^N'
fi

if (( $+widgets[fzf-history-widget] )); then
    bindkey '^R' fzf-history-widget
else
    bindkey '^R' history-incremental-search-backward
fi

autoload -Uz edit-command-line
zle -N edit-command-line
_safe_bind edit-command-line '^X^E' '^Xe'
