# 防止重复加载
if [[ -n $ZSH_MODULAR_LOADED && ! -o INTERACTIVE ]]; then
    return
fi
export ZSH_MODULAR_LOADED=1

# Basic Path
ZSH_CONFIG_DIR="$HOME/.config/zsh"
[[ -d "$HOME/.zsh/cache" ]] || mkdir -p "$HOME/.zsh/cache"

# Theme (priority load)
[[ -r "$ZSH_CONFIG_DIR/ui/p10k.zsh" ]] && source "$ZSH_CONFIG_DIR/ui/p10k.zsh"

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
source "$ZSH_CONFIG_DIR/ui/colors.zsh"
source "$ZSH_CONFIG_DIR/ui/highlight.zsh"
source "$ZSH_CONFIG_DIR/plugins/completion.zsh"
