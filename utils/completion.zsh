# --- 彩色补全模块 ---
zmodload zsh/complist 2>/dev/null

# 仅在 LS_COLORS 为空时初始化
if [[ -z "$LS_COLORS" ]]; then
    (( $+commands[dircolors] )) && eval "$(dircolors -b)"
fi

# 补全菜单风格
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# 补全器设置：普通补全 -> 通配符匹配 -> 纠错补全
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# 匹配算法：大小写不敏感、支持 ._- 分隔符模糊匹配
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# 补全菜单视觉格式化 (使用 %F 语法确保 P10K 兼容)
zstyle ':completion:*:descriptions' format '%B%F{yellow} -- %d --%f%b'
zstyle ':completion:*:messages'     format '%B%F{magenta} -- %d --%f%b'
zstyle ':completion:*:warnings'     format '%B%F{red} -- No Matches Found --%f%b'
zstyle ':completion:*:corrections'  format '%B%F{green} -- %d (errors: %e) --%f%b'

# 补全结果分组展示
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'

# 进程补全
zstyle ':completion:*:*:*:*:processes' force-list always
zstyle ':completion:*:*:*:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:processes' command 'ps -u $USER -o pid,user,comm -w -w'

# 特殊路径补全顺序 (cd ~ 时)
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'

# 行编辑高亮 (选中区域、特殊字符、搜索高亮)
zle_highlight=(
    region:bg=magenta
    special:bold
    isearch:underline
    paste:none
)

# --- 交互增强：智能 Tab 逻辑 ---
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
