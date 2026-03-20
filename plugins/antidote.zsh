ZSH_PLUGIN_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
ZSH_PLUGIN_FILE="$ZSH_PLUGIN_DIR/plugins.txt"
ZSH_BUNDLE_FILE="$ZSH_PLUGIN_DIR/plugins.zsh"

# Load antidote
if [[ -f "$HOME/.antidote/antidote.zsh" ]]; then
    source "$HOME/.antidote/antidote.zsh"
else
    echo "WARNING: Antidote not found!"
fi
antidote-update() {
    echo "Updating zsh new plugins"
    if [[ -f "$ZSH_PLUGIN_FILE" ]]; then
        antidote bundle < "$ZSH_PLUGIN_FILE" > "$ZSH_BUNDLE_FILE"
        source "$ZSH_BUNDLE_FILE"
        echo "OK: plugins success update"
    else
        echo "Error: plugins.txt file note found"
    fi
}
# Startup load logic
if [[ -f "$ZSH_BUNDLE_FILE" ]]; then
    # If plugins.zsh survival,load
    source "$ZSH_BUNDLE_FILE"
else
    echo "First start, initialization plugins"
    antidote-update
fi
