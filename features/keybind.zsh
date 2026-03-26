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

function zle-line-init() {
    [[ -n "$terminfo[smkx]" ]] && echoti smkx
}
function zle-line-finish() {
    [[ -n "$terminfo[rmkx]" ]] && echoti rmkx
}
zle -N zle-line-init
zle -N zle-line-finish

_safe_bind() {
    local widget="$1"
    shift
    if (( $+widgets[$widget] )) || (( $+functions[$widget] )); then
        for seq in "$@"; do
            [[ -n "$seq" ]] && bindkey -- "$seq" "$widget"
        done
    fi
}

_safe_bind beginning-of-line     "${key[Home]}" "^A"
_safe_bind end-of-line           "${key[End]}" "^E"
if [[ -n "${key[Insert]}" ]]; then
    if (( $+widgets[overwrite-mode] )); then
        _safe_bind overwrite-mode "${key[Insert]}"
    elif (( $+widgets[toggle-overwrite] )); then
        _safe_bind toggle-overwrite "${key[Insert]}"
    else
        _safe_bind undefined-key "${key[Insert]}"
    fi
fi
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

local up_widget="up-line-or-beginning-search"
local down_widget="down-line-or-beginning-search"
if (( $+widgets[history-substring-search-up] )); then
    up_widget="history-substring-search-up"
    down_widget="history-substring-search-down"
else
    autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
    zle -N up-line-or-beginning-search
    zle -N down-line-or-beginning-search
fi
_safe_bind "$up_widget"   "${key[Up]}"   '^[[A' '^P'
_safe_bind "$down_widget" "${key[Down]}" '^[[B' '^N'

if (( $+widgets[fzf-history-widget] )); then
    bindkey '^R' fzf-history-widget
else
    bindkey '^R' history-incremental-search-backward
fi

autoload -Uz edit-command-line
zle -N edit-command-line
if (( $+functions[edit-command-line] )); then
    _safe_bind edit-command-line '^X^E' '^Xe'
fi
