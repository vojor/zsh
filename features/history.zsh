#历史纪录条目数量
export HISTSIZE=100000
#注销后保存的历史纪录条目数量
export SAVEHIST=100000
#历史纪录文件
export HISTFILE=~/.cache/zsh/history
#以附加的方式写入历史纪录
setopt INC_APPEND_HISTORY
#如果连续输入的命令相同，历史纪录中只保留一个
setopt HIST_IGNORE_DUPS
#为历史纪录中的命令添加时间戳
setopt EXTENDED_HISTORY
#启用 cd 命令的历史纪录，cd -[TAB]进入历史路径
setopt AUTO_PUSHD
#相同的历史路径只保留一个
setopt PUSHD_IGNORE_DUPS
#在命令前添加空格，不将此命令添加到纪录文件中
setopt HIST_IGNORE_SPACE
# 多终端同步
setopt SHARE_HISTORY
# 优先删除重复命令
setopt HIST_EXPIRE_DUPS_FIRST
# 自动清除参数前空格
setopt HIST_REDUCE_BLANKS
# 不重复出现相同命令
setopt HIST_FIND_NO_DUPS
# 写文件时去重
setopt HIST_SAVE_NO_DUPS
# 执行前确认
setopt HIST_VERIFY
