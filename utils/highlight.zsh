# 变色前缀
typeset -g -a TOKENS_FOLLOWED_BY_COMMANDS
TOKENS_FOLLOWED_BY_COMMANDS=('|' '||' ';' '&' '&&' 'sudo' 'do' 'time' 'strace' 'if' 'then' 'else' 'elif' 'while' 'until')

recolor-cmd() {
    [[ -z "$BUFFER" ]] && region_highlight=() && return

    local start_pos=0 end_pos=0
    local res style arg colorize=true

    region_highlight=()

    for arg in ${(z)BUFFER}; do
        (( start_pos += ${#BUFFER[$start_pos+1,-1]} - ${#${BUFFER[$start_pos+1,-1]## #}} ))
        (( end_pos = start_pos + ${#arg} ))

        if [[ "| || ; & &&" == *"$arg"* ]]; then
            style="fg=yellow,bold"
            colorize=true
        elif $colorize; then
            colorize=false

            res=$(LC_ALL=C builtin type -w "$arg" 2>/dev/null)
            res="${res#*: }"

            case "$res" in
                'reserved') style="fg=magenta,bold" ;;
                'alias')    style="fg=cyan,bold"    ;;
                'builtin')  style="fg=yellow,bold"  ;;
                'function') style="fg=green,bold"   ;;
                'command')
                    [[ "$arg" == "sudo" ]] && style="fg=red,bold" || style="fg=blue,bold"
                    ;;
                *) style="fg=white" ;;
            esac
        else
            style="fg=244"
        fi
        region_highlight+=("$start_pos $end_pos $style")

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
widgets_to_wrap=(
    self-insert
    backward-delete-char
    delete-char-or-list
    vi-backward-delete-char
    vi-add-eol
    backward-kill-word
)

for w in $widgets_to_wrap; do
    zle -N $w _recolor_widget_wrapper
done
