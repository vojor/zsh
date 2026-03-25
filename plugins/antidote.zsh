ZSH_PLUGIN_FILE="$ZSH_CONFIG_DIR/zsh_plugins.txt"
ZSH_BUNDLE_FILE="$ZSH_CACHE_DIR/zsh_plugins.zsh"

# Load antidote
if [[ -f "${XDG_DATA_HOME}/.antidote/antidote.zsh" ]]; then
    source "${XDG_DATA_HOME}/.antidote/antidote.zsh"
    zstyle ':antidote:bundle' depth 1
else
    print -P "%F{244}[%D{%H:%M:%S}]%f %F{yellow} %BWarning:%b%f %F{242}antidote not found.%f"
fi

# Define update logic
antidote-update() {
    print -P "%F{blue}󰚰 %BUpdating bundle to install plugins...%b%f"

    if [[ -z "$all_proxy" ]] && [[ -z "$http_proxy" || -z "$https_proxy" ]]; then
        print -P "%F{244}[%D{%H:%M:%S}]%f %F{yellow} %BWarning:%b%f %F{242}No valid proxy detected. Skipping bundle update.%f"
        return 1
    fi

    if [[ -f "$ZSH_PLUGIN_FILE" ]]; then
        local TMP_BUNDLE="${ZSH_BUNDLE_FILE}.tmp"

        if antidote bundle < "$ZSH_PLUGIN_FILE" >! "$TMP_BUNDLE"; then
            if [[ -s "$TMP_BUNDLE" ]]; then
                mv -f "$TMP_BUNDLE" "$ZSH_BUNDLE_FILE"
                source "$ZSH_BUNDLE_FILE"
                print -P "%F{244}[%D{%H:%M:%S}]%f %F{green}󰄬 %BSuccess:%b%f %F{blue}Plugins bundled and loaded.%f"
            else
                print -P "%F{red}󰅚 %BError:%b%f %F{172}Generated bundle is empty.%f"
                rm -f "$TMP_BUNDLE"
                return 1
            fi
        else
            print -P "%F{red}󰅚 %BError:%b%f %F{172}Antidote bundle failed.%f"
            [[ -f "$TMP_BUNDLE" ]] && rm -f "$TMP_BUNDLE"
            return 1
        fi
    fi
}

if [[ ! -f "$ZSH_BUNDLE_FILE" || "$ZSH_PLUGIN_FILE" -nt "$ZSH_BUNDLE_FILE" ]]; then
    print -P "%F{green}󱐥 %BInitializing or updating plugins...%b%f"

    if antidote-update; then
        :
    elif [[ -f "$ZSH_BUNDLE_FILE" ]]; then
        print -P "%F{242}󰔚 %BWarning:%b%f %F{242}Update failed, falling back to existing bundle.%f"
        source "$ZSH_BUNDLE_FILE"
    else
        print -P "%F{red} %BError:%b%f %F{172}No plugins loaded.%f"
    fi
else
    source "$ZSH_BUNDLE_FILE"
fi
