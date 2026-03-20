ZSH_PLUGIN_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
ZSH_PLUGIN_FILE="$ZSH_PLUGIN_DIR/plugins.txt"
ZSH_BUNDLE_FILE="$ZSH_PLUGIN_DIR/plugins.zsh"

# if not bundle or update txt file
if [[ ! -f $ZSH_BUNDLE_FILE || $ZSH_PLUGIN_FILE -nt $ZSH_BUNDLE_FILE ]]; then
    source ~/.antidote/antidote.zsh
    antidote bundle < "$ZSH_PLUGIN_FILE" > "$ZSH_BUNDLE_FILE"
fi

# Load plugin
source "$ZSH_BUNDLE_FILE"
