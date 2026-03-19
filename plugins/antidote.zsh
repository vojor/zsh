# Antidote plugin manager
source ~/.antidote/antidote.zsh

# 插件列表文件
zstyle ':antidote:bundle' file ~/.config/zsh/plugins.txt

# 生成 bundle（第一次执行）
if [[ ! -f ~/.config/zsh/plugins.zsh ]]; then
  antidote bundle < ~/.config/zsh/plugins.txt > ~/.config/zsh/plugins.zsh
fi

# 加载插件
source ~/.config/zsh/plugins.zsh
