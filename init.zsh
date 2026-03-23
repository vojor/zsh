# 防止重复加载
if [[ -n $ZSH_MODULAR_LOADED && ! -o INTERACTIVE ]]; then
    return
fi
typeset -g ZSH_MODULAR_LOADED=1

# boot
source "$ZSH_CONFIG_DIR/boot/proxy.zsh"

# 核心和基础配置
source "$ZSH_CONFIG_DIR/core/path.zsh"
source "$ZSH_CONFIG_DIR/core/env.zsh"
source "$ZSH_CONFIG_DIR/core/history.zsh"
source "$ZSH_CONFIG_DIR/core/colors.zsh"
source "$ZSH_CONFIG_DIR/core/options.zsh"

# Completion priority initialization
ZSH_COMPDUMP="${ZSH_CACHE_DIR}/zcompdump"

autoload -Uz compinit
if [[ -n "$ZSH_COMPDUMP"(#qN.mh-12) ]]; then
    compinit -C -d "$ZSH_COMPDUMP"
else
    compinit -d "$ZSH_COMPDUMP"
fi

{
    if [[ -s "$ZSH_COMPDUMP" ]]; then
        if [[ ! -s "${ZSH_COMPDUMP}.zwc" || "$ZSH_COMPDUMP" -nt "${ZSH_COMPDUMP}.zwc" ]]; then
            zcompile "$ZSH_COMPDUMP"
        fi
    fi
} &!
source "$ZSH_CONFIG_DIR/utils/completion.zsh"
zmodload zsh/complist 2>/dev/null

# 插件加载及配置
source "$ZSH_CONFIG_DIR/plugins/antidote.zsh"

# 功能优化
source "$ZSH_CONFIG_DIR/extend/misc.zsh"
source "$ZSH_CONFIG_DIR/extend/yazi.zsh"

source "$ZSH_CONFIG_DIR/utils/highlight.zsh"

source "$ZSH_CONFIG_DIR/features/keybind.zsh"
source "$ZSH_CONFIG_DIR/features/alias.zsh"
