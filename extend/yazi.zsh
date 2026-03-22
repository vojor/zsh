y() {
  local tmp
  local cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/yazi"
  [[ -d "$cache_dir" ]] || mkdir -p "$cache_dir"

  tmp=$(mktemp "$cache_dir/cwd.XXXXXX") || return

  command yazi "$@" --cwd-file="$tmp"

  if [[ -f "$tmp" ]]; then
    local cwd=$(<"$tmp")
    if [[ -n "$cwd" && "$cwd" != "$PWD" ]]; then
      builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
  fi
}
