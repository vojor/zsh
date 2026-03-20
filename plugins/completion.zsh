# 彩色补全
(( $+commands[dircolors] )) && eval "$(dircolors -b)"
zmodload zsh/complist

# 允许方向键选择，并显示彩色列表
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

# 大小写容错
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# 错误纠正
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# 命令特定补全 (Kill/Ps)
zstyle ':completion:*:*:*:*:processes' force-list always
zstyle ':completion:*:*:*:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:processes' command 'ps -au$USER'

# 分组与提示文字
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:descriptions' format $'\e[01;33m -- %d --\e[0m'
zstyle ':completion:*:messages' format $'\e[01;35m -- %d --\e[0m'
zstyle ':completion:*:warnings' format $'\e[01;31m -- No Matches Found --\e[0m'
zstyle ':completion:*:corrections' format $'\e[01;32m -- %d (errors: %e) --\e[0m'

# cd ~ 补全顺序
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'

# 行编辑高亮
zle_highlight=(
    region:bg=magenta
    special:bold
    isearch:underline
    paste:none
)
# 增强版 Tab 逻辑
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
