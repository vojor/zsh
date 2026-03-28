# 防止重复加载
if [[ -n $ZSH_MODULAR_LOADED && ! -o INTERACTIVE ]]; then
    return
fi
typeset -g ZSH_MODULAR_LOADED=1

# 代理配置
source "$ZSH_CONFIG_DIR/boot/proxy.zsh"
# 核心和基础配置
source "$ZSH_CONFIG_DIR/core/path.zsh"
source "$ZSH_CONFIG_DIR/core/env.zsh"
source "$ZSH_CONFIG_DIR/core/history.zsh"
source "$ZSH_CONFIG_DIR/core/colors.zsh"
source "$ZSH_CONFIG_DIR/core/options.zsh"
# 底层交互
zmodload zsh/complist 2>/dev/null
# 插件加载及配置
source "$ZSH_CONFIG_DIR/plugins/antidote.zsh"
# 彩色界面，补全配置
source "$ZSH_CONFIG_DIR/utils/completion.zsh"
# 功能优化 (定义功能)
source "$ZSH_CONFIG_DIR/extend/misc.zsh"
source "$ZSH_CONFIG_DIR/extend/yazi.zsh"
source "$ZSH_CONFIG_DIR/extend/archive.zsh"
# 高亮挂载
source "$ZSH_CONFIG_DIR/utils/colorscheme.zsh"
# 按键绑定和定义别名
source "$ZSH_CONFIG_DIR/features/alias.zsh"
source "$ZSH_CONFIG_DIR/features/keybind.zsh"

# 有用的工具函数
source "$ZSH_CONFIG_DIR/extend/updatecli.zsh"
