# --- Zoxide ---
ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
ZOXIDE_CACHE="$ZSH_CACHE_DIR/zoxide_init.zsh"
ZOXIDE_BIN=$(whence -p zoxide)

[[ -d "$ZSH_CACHE_DIR" ]] || mkdir -p "$ZSH_CACHE_DIR" >/dev/null 2>&1

if [[ -n "$ZOXIDE_BIN" ]]; then
    if [[ ! -f "$ZOXIDE_CACHE" || "$ZOXIDE_BIN" -nt "$ZOXIDE_CACHE" ]]; then
        "$ZOXIDE_BIN" init zsh >| "$ZOXIDE_CACHE" 2>/dev/null
    fi

    if [[ -r "$ZOXIDE_CACHE" ]]; then
        source "$ZOXIDE_CACHE"
    fi
else
    :
fi

# --- Fzf ---
if (( $+commands[fd] )); then
    export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
elif (( $+commands[rg] )); then
    export FZF_DEFAULT_COMMAND='rg --files'
fi
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

local preview_logic='[[ -d {} ]] && eza --tree --color=always --icons {} | head -200 || (bat --color=always --style=numbers --line-range :500 {} 2>/dev/null || cat {})'

export FZF_DEFAULT_OPTS="
  --height 45%
  --layout=reverse
  --border
  --info=inline
  --preview '$preview_logic'
  --preview-window=right:60%:wrap
  --bind 'ctrl-/:toggle-preview'
  --color=header:italic
"
