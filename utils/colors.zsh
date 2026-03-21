typeset -g -A FG FG_BOLD

() {
    local color
    for color in red green yellow blue magenta cyan white black; do
        FG[$color]="%F{$color}"
        FG_BOLD[$color]="%B%F{$color}"
    done
}

export FINISH="%f%b"

if [[ "$TERM" == (xterm*|rxvt*|*term) && -z "$VIMRUNTIME" ]]; then
    set_terminal_title() {
        print -Pn "\e]0;%n@%m: %~\a"
    }

    if [[ -z "${precmd_functions[(r)set_terminal_title]}" ]]; then
        precmd_functions+=(set_terminal_title)
    fi
fi
