# --- Zoxide ---
ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
ZOXIDE_CACHE="$ZSH_CACHE_DIR/zoxide_init.zsh"
ZOXIDE_BIN=$(whence -p zoxide)

[[ -d "$ZSH_CACHE_DIR" ]] || mkdir -p "$ZSH_CACHE_DIR"

# 仅在必要时生成缓存
if [[ -n "$ZOXIDE_BIN" ]]; then
    if [[ ! -f "$ZOXIDE_CACHE" || "$ZOXIDE_BIN" -nt "$ZOXIDE_CACHE" ]]; then
        zoxide init zsh >| "$ZOXIDE_CACHE"
    fi
    source "$ZOXIDE_CACHE"
else
    return 1 2>/dev/null
fi
