if (( $+commands[direnv] )); then
    DIRENV_CACHE="$ZSH_CACHE_DIR/direnv_init.zsh"
    DIRENV_BIN=$(whence -p direnv)
    if [[ -n "$DIRENV_BIN" ]]; then
        if [[ ! -f "$DIRENV_CACHE" || "$DIRENV_BIN" -nt "$DIRENV_CACHE" ]]; then
            "$DIRENV_BIN" hook zsh >| "$DIRENV_CACHE" 2>/dev/null
            zrecompile -pq "$DIRENV_CACHE"
        fi
        if [[ -r "$DIRENV_CACHE" ]]; then
            source "$DIRENV_CACHE"
        fi
    else
        :
    fi
fi

if (( $+commands[zoxide] )); then
    ZOXIDE_CACHE="$ZSH_CACHE_DIR/zoxide_init.zsh"
    ZOXIDE_BIN=$(whence -p zoxide)
    if [[ -n "$ZOXIDE_BIN" ]]; then
        if [[ ! -f "$ZOXIDE_CACHE" || "$ZOXIDE_BIN" -nt "$ZOXIDE_CACHE" ]]; then
            "$ZOXIDE_BIN" init zsh >| "$ZOXIDE_CACHE" 2>/dev/null
            zrecompile -pq "$ZOXIDE_CACHE"
        fi
        if [[ -r "$ZOXIDE_CACHE" ]]; then
            source "$ZOXIDE_CACHE"
        fi
    else
        :
    fi
fi

if (( $+commands[fzf] )); then
    export FZF_DEFAULT_OPTS="
        --height 45% --layout=reverse --border --info=inline
        --bind 'ctrl-/:toggle-preview'
        --bind 'alt-j:preview-down,alt-k:preview-up'
        --color=header:italic
    "
    if (( $+commands[fd] )); then
        export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
    elif (( $+commands[rg] )); then
        export FZF_DEFAULT_COMMAND='rg --files'
    fi

    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_CTRL_T_OPTS='
        --preview "
        if [[ -d {} ]]; then
            eza --tree --color=always --icons {} | head -200
        elif [[ ! -s {} ]]; then
            print -P \"%F{yellow}󰟢 Empty File%f\"
        else
            if file --mime {} | grep -q \"binary\"; then
                print -P \"%F{cyan}󰈲 Preview Unavailable%f\"
                file -b {}
            else
                bat --color=always --style=numbers --line-range :500 {} 2>/dev/null || cat {}
            fi
        fi"
        --preview-window=right:60%:wrap
    '
    export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:wrap"
    export FZF_ALT_C_COMMAND="fd --type d --hidden --strip-cwd-prefix --exclude .git"
    export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always --icons {} | head -200'"

    FZF_CACHE="$ZSH_CACHE_DIR/fzf_init.zsh"
    FZF_BIN=$(whence -p fzf)
    if [[ -n "$FZF_BIN" ]]; then
        if [[ ! -f "$FZF_CACHE" || "$FZF_BIN" -nt "$FZF_CACHE" ]]; then
            "$FZF_BIN" --zsh >| "$FZF_CACHE" 2>/dev/null
            zrecompile -pq "$FZF_CACHE"
        fi
        if [[ -r "$FZF_CACHE" ]]; then
            source "$FZF_CACHE"
        fi
    else
        :
    fi
fi

# vi-mode
export KEYTIMEOUT=20
ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
ZVM_CURSOR_STYLE_ENABLED=true
ZVM_HIGHLIGHT_ALL_COMMANDS=false
ZVM_AUTO_UPDATE=false
ZVM_VI_INSERT_ESCAPE_BINDKEY=jk
ZVM_VI_EDITOR="nvim"
ZVM_INIT_MODE=sourcing
