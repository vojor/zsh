# yazi 快速跳转

y() {
  local tmp cwd
  tmp=$(mktemp -t yazi-cwd.XXXXXX) || return

  command yazi "$@" --cwd-file="$tmp"

  if [[ -f $tmp ]]; then
    cwd=$(<"$tmp")
    [[ -n $cwd && $cwd != $PWD ]] && builtin cd -- "$cwd"
    rm -f -- "$tmp"
  fi
}
