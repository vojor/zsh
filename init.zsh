# 防止重复加载
[[ -n $ZSH_MODULAR_LOADED ]] && return
export ZSH_MODULAR_LOADED=1

# 基础路径
ZSH_CONFIG_DIR="$HOME/.config/zsh"

# 主题（必须最早）
source $ZSH_CONFIG_DIR/ui/p10k.zsh

# 补全优先初始化
autoload -Uz compinit
compinit -d ~/.zsh/cache/zcompdump -C

# 插件系统
source $ZSH_CONFIG_DIR/plugins/antidote.zsh

# 核心配置
source $ZSH_CONFIG_DIR/core/env.zsh
source $ZSH_CONFIG_DIR/core/path.zsh
source $ZSH_CONFIG_DIR/core/options.zsh
source $ZSH_CONFIG_DIR/core/keybind.zsh

# 功能模块
source $ZSH_CONFIG_DIR/features/alias.zsh
source $ZSH_CONFIG_DIR/features/history.zsh
source $ZSH_CONFIG_DIR/features/yazi.zsh
source $ZSH_CONFIG_DIR/features/misc.zsh

# UI 增强
source $ZSH_CONFIG_DIR/ui/colors.zsh
source $ZSH_CONFIG_DIR/ui/highlight.zsh

# 补全（最后）
source $ZSH_CONFIG_DIR/plugins/completion.zsh
