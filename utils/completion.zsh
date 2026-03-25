# 优先使用 vivid。否则退回 LS_COLORS, 仅在 LS_COLORS 为空时初始化
if [[ -z "$LS_COLORS" ]]; then
    if (( $+commands[vivid] )); then
        export LS_COLORS="$(vivid generate tokyonight-night)"
    elif (( $+commands[dircolors] )); then
        eval "$(dircolors -b)"
    fi
fi

# 补全菜单风格
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# 别名展开 -> 普通补全 -> 后缀补全 -> 模糊匹配 -> 纠错
zstyle ':completion:*' completer _expand_alias _complete _extensions _match _approximate

# 匹配算法：大小写不敏感、支持 ._- 分隔符模糊匹配
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# 补全菜单视觉格式化
zstyle ':completion:*:descriptions' format '%B%F{yellow}󱆃 %d%f%b'
zstyle ':completion:*:messages'     format '%B%F{magenta}󰍡 %d%f%b'
zstyle ':completion:*:warnings'     format '%B%F{red}󰅚 No Matches Found%f%b'
zstyle ':completion:*:corrections'  format '%B%F{green}󰁨 %d (errors: %e)%f%b'

# 补全结果分组展示
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'

# 排除不必要的系统账户补全 (减少 Tab 时的干扰)
zstyle ':completion:*:*:*:users' ignored-patterns \
    adm amanda apache at avahi bin daemon dbus ftp gcc gopher \
    halt daemon lp mail mlocate mysql named netdump noaccess nobody \
    ntp operator pcap postgres privoxy proxy puppet qmaild qmaill \
    qmailp qmailq qmails qmailt root sge shadow shutdown squid \
    sshd sync sys uucp vcsa xfs '_*'

# 进程补全
zstyle ':completion:*:*:*:*:processes' force-list always
zstyle ':completion:*:*:*:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:processes' command 'ps -u $USER -o pid,user,comm -w -w'

# 路径补全：禁止补全当前目录 (./)
zstyle ':completion:*' ignore-parents parent pwd

# 特殊路径补全顺序
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'

# 行编辑高亮 (选中区域、特殊字符、搜索高亮)
typeset -g -a zle_highlight
zle_highlight=(
    region:fg=white,bg=magenta
    special:bold
    isearch:underline
    paste:standout
    suffix:bold
)

# Tab 逻辑
user-complete(){
    case "$BUFFER" in
        "" )           BUFFER="cd "; zle end-of-line; zle expand-or-complete ;;
        "cd --" )      BUFFER="cd +"; zle end-of-line; zle expand-or-complete ;;
        "cd +-" )      BUFFER="cd -"; zle end-of-line; zle expand-or-complete ;;
        ".." )         BUFFER="../"; zle end-of-line; zle expand-or-complete ;;
        * )            zle expand-or-complete ;;
    esac
}
zle -N user-complete
bindkey "\t" user-complete
bindkey -M menuselect '/' history-incremental-search-forward
