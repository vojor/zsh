# Zsh Config

- Use antidote config zsh

- dot_zshrc

```sh
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ZSH Config Dir
export ZSH_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

# Boot start, proxy set
source "$ZSH_CONFIG_DIR/boot/proxy.zsh"

# Load zsh configure
ZSH_INIT_FILE="$ZSH_CONFIG_DIR/init.zsh"
if [[ -f "$ZSH_INIT_FILE" ]]; then
    source "$ZSH_INIT_FILE"
else
    echo "Error: initialization file not found"
fi

[[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

```
