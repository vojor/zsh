ZSH_PLUGIN_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
ZSH_PLUGIN_FILE="$ZSH_PLUGIN_DIR/plugins.txt"
ZSH_BUNDLE_FILE="$ZSH_PLUGIN_DIR/plugins.zsh"

# Load antidote
if [[ -f "$HOME/.antidote/antidote.zsh" ]]; then
    source "$HOME/.antidote/antidote.zsh"
    zstyle ':antidote:bundle' depth 1
else
    echo "Warning: Antidote not found!"
fi

# Define update logic
antidote-update() {
    echo "Updating zsh plugins bundle..."

    if [[ -z "$all_proxy" && -z "$http_proxy" -z "$https_proxy" ]]; then
        echo "Warning: No proxy detected. Plugin download might fail or hang."
    fi

    if [[ -f "$ZSH_PLUGIN_FILE" ]]; then
        local TMP_BUNDLE="${ZSH_BUNDLE_FILE}.tmp"

        echo "Run antidote bundle..."

        if antidote bundle < "$ZSH_PLUGIN_FILE" > "$TMP_BUNDLE"; then
            mv "$TMP_BUNDLE" "$ZSH_BUNDLE_FILE"
            source "$ZSH_BUNDLE_FILE"

            echo "Success: plugins bundle and loaded"
        else
            echo "Error: antidote bundle failed。"
            echo "Retain original configuration，please check network."

            [[ -f "$TMP_BUNDLE" ]] && rm "$TMP_BUNDLE"
            return 1
        fi
    else
        echo "Error: plugins.txt file note found"
        return 1
    fi
}
# Startup load logic
if [[ -f "$ZSH_BUNDLE_FILE" ]]; then
    source "$ZSH_BUNDLE_FILE"
else
    echo "First start, initializing plugins"
    antidote-update
fi
