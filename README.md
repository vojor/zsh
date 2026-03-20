# Zsh Config

- Use antidote config zsh

- dot_zshrc

```sh
# Proxy configure
proxy_on() {
    export http_proxy="http://192.168.176.1:10810"
    export https_proxy="http://192.168.176.1:10810"
    export all_proxy="http://192.168.176.1:10810"
    echo "Proxy On"
}

proxy_off() {
    unset http_proxy https_proxy all_proxy
    echo "Proxy Off"
}

# Master Load
source ~/.config/zsh/init.zsh

# Load flied notify
ZSH_INIT_FILE="$HOME/.config/zsh/init.zsh"
if [[ -f "$ZSH_INIT_FILE" ]]; then
    source "$ZSH_INIT_FILE"
else
    echo "Error: initialization file not found"
fi
```
