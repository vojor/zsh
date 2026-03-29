# Configure your ZSH

> **Use antidote config zsh**

- Introduction: zsh use **fzf-tab,p10k,zsh-suggestions** etc plugins, very beautify,practical and power.

## Ensure terminal is **zsh**

1. Install necessary CLI programs and nerdfonts.

- CLI programs: **_bsdtar,fd,fzf,git,eza,ripgrep,ugrep,zoxide_**.
- Goto [nerdfonts](https://www.nerdfonts.com) website, download you like nerdfont.

2. Download and install antidote plugin.

- Terminal enter: `git clone --depth=1 https://github.com/mattmc3/antidote.git $HOME/.local/share/.antidote`

3. Configure zsh

- Terminal enter: `git clone --depth=1 https://github.com/vojor/zsh.git $HOME/.config/zsh`

4. configure zsh start

- Terminal enter: `rm ~/.zshrc && touch ~/.zshrc`
- copy up to `.zshrc`
- startup: `exec zsh`

```sh
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export ZSH_CONFIG_DIR="${XDG_CONFIG_HOME}/zsh"
export ZSH_CACHE_DIR="${XDG_CACHE_HOME}/zsh"
export ZSH_DATA_DIR="${XDG_DATA_HOME}/zsh"
export ZSH_STATE_DIR="${XDG_STATE_HOME}/zsh"
mkdir -p "$ZSH_CONFIG_DIR" "$ZSH_CACHE_DIR" "$ZSH_DATA_DIR" "$ZSH_STATE_DIR" 2>/dev/null

if [[ ! -f "${XDG_DATA_HOME}/.antidote/antidote.zsh" ]]; then
    if [[ -n "$all_proxy" || -n "$http_proxy" || -n "$https_proxy" ]]; then
        print -P "%F{blue}󰏗 %BDetecting proxy, auto-installing Antidote...%b%f"
        if git clone --depth=1 https://github.com/mattmc3/antidote.git "${XDG_DATA_HOME}/.antidote" &>/dev/null;then
            print -P "%F{green}󰄬 Antidote installed successfully!%f"

            local deps=("bsdtar" "eza" "fzf" "fd" "rg" "ugrep" "zoxide")
            local missing=()
            for tool in $deps; do
                if ! command -v "$tool" &>/dev/null; then missing+=("$tool"); fi
            done

            if [[ ${#missing[@]} -gt 0 ]]; then
                print -P "\n%F{160}󰅚 %BDependency Check Failed:%b%f"
                print -P "%F{214}󱁤 Missing tools: %B${missing[*]}%b%f"
                print -P "%F{76}󰑓 Please install them, then run: %B%F{32}source ~/.zshrc%b%f\n"
                return 1
            fi
        fi
    else
        print -P "%F{yellow} %BWarning:%b No proxy detected. Skipping install antidote.%f"
        return 1
    fi
fi

ZSH_INIT_FILE="${ZSH_CONFIG_DIR}/init.zsh"
if [[ -f "$ZSH_INIT_FILE" ]]; then
    source "$ZSH_INIT_FILE"
else
    print -P "%F{red}󰅚 %BError:%b%f %F{172}Initialization file not found.%f"
fi

[[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"
```

- 5. Plugins auto install.
