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
