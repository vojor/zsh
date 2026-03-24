ZSH_PLUGIN_FILE="$ZSH_CONFIG_DIR/plugins.txt"
ZSH_BUNDLE_FILE="$ZSH_CACHE_DIR/plugins.zsh"

# Load antidote
if [[ -f "${XDG_DATA_HOME}/.antidote/antidote.zsh" ]]; then
    source "${XDG_DATA_HOME}/.antidote/antidote.zsh"
    zstyle ':antidote:bundle' depth 1
else
    print -P "%F{244}[%D{%H:%M:%S}]%f %F{yellow} %BWarning:%b%f %F{242}Antidote not found.%f"
fi

# Define update logic
antidote-update() {
    print -P "%F{blue}󰚰 %BUpdating plugins bundle...%b%f"

    if [[ -z "$all_proxy" && -z "$http_proxy" && -z "$https_proxy" ]]; then
        print -P "%F{244}[%D{%H:%M:%S}]%f %F{yellow} %BWarning:%b%f %F{242}No proxy detected, Skipping plugin install.%f"
    fi

    if [[ -f "$ZSH_PLUGIN_FILE" ]]; then
        local TMP_BUNDLE="${ZSH_BUNDLE_FILE}.tmp"

        print -P "%F{blue}󱓞 %BRun antidote bundle...%b%f"

        if antidote bundle < "$ZSH_PLUGIN_FILE" > "$TMP_BUNDLE"; then
            mv "$TMP_BUNDLE" "$ZSH_BUNDLE_FILE"
            source "$ZSH_BUNDLE_FILE"

            print -P "%F{244}[%D{%H:%M:%S}]%f %F{green}󰄬 %BSuccess:%b%f %F{blue}plugins bundle and loaded.%f"
        else
            print -P "%F{244}[%D{%H:%M:%S}]%f %F{red}󰅚 %BError:%b%f %F{172}antidote bundle failed, retain..., check network%f"

            [[ -f "$TMP_BUNDLE" ]] && rm "$TMP_BUNDLE"
            return 1
        fi
    else
        print -P "%F{244}[%D{%H:%M:%S}]%f %F{red}󰅚 %BError:%b%f %F{172}plugins.txt file not found%f"
        return 1
    fi
}
# Startup load logic
if [[ -f "$ZSH_BUNDLE_FILE" && "$ZSH_PLUGIN_FILE" -ot "$ZSH_BUNDLE_FILE" ]]; then
    source "$ZSH_BUNDLE_FILE"
else
    print -P "%F{green}󱐥 %BInitializing or updating plugins...%b%f"
    antidote-update
fi
