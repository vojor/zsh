setopt extended_glob

# 除法新的变色符号
TOKENS_FOLLOWED_BY_COMMANDS=('|' '||' ';' '&' '&&' 'sudo' 'do' 'time' 'strace')

recolor-cmd() {
    [[ -z "$BUFFER" ]] && region_highlight=() && return

    region_highlight=()
    local colorize=true
    local start_pos=0
    local end_pos=0
    local res style arg

    for arg in ${(z)BUFFER}; do
        ((start_pos+=${#BUFFER[$start_pos+1,-1]}-${#${BUFFER[$start_pos+1,-1]## #}}))
        ((end_pos=$start_pos+${#arg}))

        if $colorize; then
            colorize=false
            res=$(LC_ALL=C builtin type "$arg" 2>/dev/null)
            case "$res" in
                *'reserved word'*)  style="fg=magenta,bold";;
                *'alias for'*)      style="fg=cyan,bold";;
                *'shell builtin'*)  style="fg=yellow,bold";;
                *'shell function'*) style='fg=green,bold';;
                *"$arg is"*)
                    [[ "$arg" = 'sudo' ]] && style="fg=red,bold" || style="fg=blue,bold";;
                *)                  style='fg=white';; # 参数或未知命令
            esac
            region_highlight+=("$start_pos $end_pos $style")
        else
            region_highlight+=("$start_pos $end_pos fg=gray")
        fi

        if [[ ${TOKENS_FOLLOWED_BY_COMMANDS[(r)$arg]} == "$arg" ]]; then
            colorize=true
        fi
        start_pos=$end_pos
    done

}
# 避免多次定义重复代码
_recolor_widget_wrapper() {
    zle .${WIDGET}
    recolor-cmd
}

# 自动为常用的编辑操作挂载高亮
local -a widgets_to_wrap
widgets_to_wrap=(self-insert backward-delete-char delete-char-or-list vi-backward-delete-char vi-add-eol)

for w in $widgets_to_wrap; do
    zle -N $w _recolor_widget_wrapper
done
