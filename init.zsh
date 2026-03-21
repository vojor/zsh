[[ -r "$HOME/.config/zsh/scheme/start_p10k.zsh" ]] && source "$HOME/.config/zsh/scheme/start_p10k.zsh"
# 防止重复加载
if [[ -n $ZSH_MODULAR_LOADED && ! -o INTERACTIVE ]]; then
    return
fi
export ZSH_MODULAR_LOADED=1

# Basic Path
ZSH_CONFIG_DIR="$HOME/.config/zsh"
[[ -d "$HOME/.zsh/cache" ]] || mkdir -p "$HOME/.zsh/cache"

# Completion priority initialization
autoload -Uz compinit
compinit -i -u -d "$HOME/.zsh/cache/zcompdump" -C

# 插件系统
source "$ZSH_CONFIG_DIR/plugins/antidote.zsh"
# 模块化加载配置 (注意加载顺序)
source "$ZSH_CONFIG_DIR/core/env.zsh"
source "$ZSH_CONFIG_DIR/core/path.zsh"
source "$ZSH_CONFIG_DIR/core/options.zsh"
source "$ZSH_CONFIG_DIR/core/keybind.zsh"

source "$ZSH_CONFIG_DIR/features/alias.zsh"
source "$ZSH_CONFIG_DIR/features/history.zsh"
source "$ZSH_CONFIG_DIR/features/yazi.zsh"
source "$ZSH_CONFIG_DIR/features/misc.zsh"

source "$ZSH_CONFIG_DIR/utils/colors.zsh"
source "$ZSH_CONFIG_DIR/utils/highlight.zsh"
source "$ZSH_CONFIG_DIR/utils/completion.zsh"

[[ -f "$ZSH_CONFIG_DIR/scheme/end_p10k.zsh" ]] && source "$ZSH_CONFIG_DIR/scheme/end_p10k.zsh"
