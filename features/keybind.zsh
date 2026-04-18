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
_safe_bind delete-char           "${key[Delete]}"
_safe_bind backward-delete-char  "${key[Backspace]}" "^?" "^H"
_safe_bind clear-screen          "^L"
_safe_bind backward-kill-word     '^W'
local overwrite_widget="undefined-key"
(( $+widgets[overwrite-mode] )) && overwrite_widget="overwrite-mode"
(( $+widgets[toggle-overwrite] )) && overwrite_widget="toggle-overwrite"
if [[ -n "${key[Insert]}" ]]; then
    _safe_bind "$overwrite_widget" "${key[Insert]}"
fi

zle -N edit-command-line
if (( $+functions[edit-command-line] )); then
    _safe_bind edit-command-line '^X^E' '^Xe'
fi

typeset -g HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS='i'
typeset -g HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='fg=magenta,bold'
typeset -g HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='fg=red,bold'

local up_widget="up-line-or-beginning-search"
local down_widget="down-line-or-beginning-search"
if (( $+widgets[history-substring-search-up] )); then
    up_widget="history-substring-search-up"
    down_widget="history-substring-search-down"
else
    zle -N up-line-or-beginning-search
    zle -N down-line-or-beginning-search
fi

function zvm_after_init() {
    zvm_bindkey viins '^R' fzf-history-widget
    zvm_bindkey vicmd '^R' fzf-history-widget
    zvm_bindkey viins '^T' fzf-file-widget
    zvm_bindkey vicmd '^T' fzf-file-widget
    zvm_bindkey viins '^[c' fzf-cd-widget
    zvm_bindkey vicmd '^[c' fzf-cd-widget
    zvm_bindkey viins '^I' user-complete


    zvm_bindkey viins "${key[Up]}"   "$up_widget"
    zvm_bindkey viins '^[[A'         "$up_widget"
    zvm_bindkey viins '^P'           "$up_widget"
    zvm_bindkey viins "${key[Down]}" "$down_widget"
    zvm_bindkey viins '^[[B'         "$down_widget"
    zvm_bindkey viins '^N'           "$down_widget"

    zvm_bindkey viins '^[[1;5C' forward-word
    zvm_bindkey viins '^[[1;5D' backward-word
    zvm_bindkey viins '^[[1;3C' forward-word
    zvm_bindkey viins '^[[1;3D' backward-word
    zvm_bindkey viins '^[f'     forward-word
    zvm_bindkey viins '^[b'     backward-word

    zvm_bindkey viins '^[d'     kill-word
    zvm_bindkey viins '^[[3;5~' kill-word
    [[ -n "${key[Insert]}" ]] && zvm_bindkey viins "${key[Insert]}" "$overwrite_widget"
}
