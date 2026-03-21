# Zsh Config

- Use antidote config zsh

- dot_zshrc

```sh
# ZSH Path
ZSH_CONFIG_DIR="$HOME/.config/zsh"

source "$ZSH_CONFIG_DIR/boot/proxy.zsh"

# Load flied notify
ZSH_INIT_FILE="$ZSH_CONFIG_DIR/init.zsh"
if [[ -f "$ZSH_INIT_FILE" ]]; then
    source "$ZSH_INIT_FILE"
else
    echo "Error: initialization file not found"
fi
```
