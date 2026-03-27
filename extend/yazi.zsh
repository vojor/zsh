y() {
  local yazi_tmp
  local cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/yazi"
  [[ -d "$cache_dir" ]] || mkdir -p "$cache_dir"

  yazi_tmp=$(mktemp "$cache_dir/cwd.XXXXXX") || return

  command yazi "$@" --cwd-file="$yazi_tmp"

  if [[ -f "$yazi_tmp" ]]; then
    local cwd=$(<"$yazi_tmp")
    if [[ -n "$cwd" && "$cwd" != "$PWD" ]]; then
      builtin cd -- "$cwd"
    fi
    rm -f -- "$yazi_tmp"
  fi
}
