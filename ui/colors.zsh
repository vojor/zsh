#auto loaded colors function
autoload -U colors && colors

typeset -A FG FG_BOLD

for color in red green yellow blue magenta cyan white; do
  FG[$color]="%{$fg[$color]%}"
  FG_BOLD[$color]="%{$terminfo[bold]$fg[$color]%}"
done

FINISH="%{$terminfo[sgr0]%}"

#标题栏、任务栏样式
case $TERM in (*xterm*|*rxvt*|(dt|k|E)term)
precmd () { print -Pn "\e]0;%n@%M//%/\a" }
preexec () { print -Pn "\e]0;%n@%M//%/\ $1\a" }
;;
esac
