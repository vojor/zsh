#历史纪录条目数量
export HISTSIZE=100000
#保存的历史纪录条目数量
export SAVEHIST=100000
#历史纪录文件位置
export HISTFILE="${ZSH_DATA_DIR}/history"

# 同步策略
#以附加的方式写入历史纪录
setopt INC_APPEND_HISTORY
#立即写入，多端同步
setopt SHARE_HISTORY
#执行前确认
setopt HIST_VERIFY

# 过滤
#忽略连续重复
setopt HIST_IGNORE_DUPS
#保留唯一
setopt HIST_IGNORE_ALL_DUPS
#写文件时去重
setopt HIST_SAVE_NO_DUPS
#不重复出现相同命令
setopt HIST_FIND_NO_DUPS
#优先删除历史文件中的重复条目
setopt HIST_EXPIRE_DUPS_FIRST
#命令前有空格则不记录
setopt HIST_IGNORE_SPACE
#自动清除多余空格
setopt HIST_REDUCE_BLANKS

# 增强功能
#为历史纪录中的命令添加时间戳
setopt EXTENDED_HISTORY
#启用 cd 命令的历史纪录
setopt AUTO_PUSHD
#相同的历史路径只保留一个
setopt PUSHD_IGNORE_DUPS
#路径列表不要占满屏幕
setopt PUSHD_SILENT
