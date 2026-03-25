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

# Tab 逻辑 (调用 fzf-tab 插件)
user-complete(){
    case "$BUFFER" in
        "" )
            BUFFER="cd "
            zle end-of-line
            zle fzf-tab-complete
            ;;
        ".." )
            BUFFER="../"
            zle end-of-line
            zle fzf-tab-complete
            ;;
        * )
            if (( $+widgets[fzf-tab-complete] )); then
                zle fzf-tab-complete
            else
                zle expand-or-complete
            fi
            ;;
    esac
}
zle -N user-complete
if [[ -n "${key[Tab]}" ]]; then
    bindkey -- "${key[Tab]}" user-complete
fi

# 预览逻辑变量
local ft_preview_cmd='
  if [[ -d $realpath ]]; then
    eza --tree --color=always --icons $realpath | head -200
  else
    bat --color=always --style=numbers --line-range :500 $realpath 2>/dev/null || cat $realpath
  fi
'
# 全局外观与交互
zstyle ':fzf-tab:*' fzf-flags '--preview-window=right:60%:wrap' \
                              '--bind=ctrl-/:toggle-preview' \
                              '--bind=alt-j:preview-down,alt-k:preview-up' \
                              '--layout=reverse'
# 核心补全预览
zstyle ':fzf-tab:complete:*:*' fzf-preview $ft_preview_cmd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always --icons $realpath'
# 特殊补全预览
zstyle ':fzf-tab:complete:kill:argument-rest' fzf-preview 'ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:kill:argument-rest' fzf-flags '--preview-window=down:3:wrap'
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'systemctl status $word'
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' fzf-preview 'echo ${(P)word}'
# 颜色分组
zstyle ':fzf-tab:*' group-colors $'\033[32m' $'\033[33m' $'\033[35m' $'\033[31m'
