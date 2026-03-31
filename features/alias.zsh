smart_alias() {
    local primary=$1
    local target=$2
    local fallback=$3

    if [[ -z "$3" ]]; then
        target=$2
        fallback=""
    fi

    if ! (( $+commands[$primary] || $+functions[$primary] || $+builtins[$primary] )); then
        alias "$primary"="$target"

    elif [[ -n "$fallback" ]] && ! (( $+commands[$fallback] || $+functions[$fallback] )); then
        alias "$fallback"="$target"

    else
        if [[ "$primary" != "$target" ]]; then
            alias "${primary}_custom"="$target"
            print -P "%F{214} Warning: '$primary' & fallback taken. Use %B${primary}_custom%b for '$target'%f"
        fi
    fi
}
# refactor
alias sudo='sudo '
alias time='time '
alias watch='watch '
alias xargs='xargs '
# security
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv --preserve-root'
alias mkdir='mkdir -pv'
alias chmod='chmod --preserve-root -v'
alias chown='chown --preserve-root -v'
alias chgrp='chgrp --preserve-root -v'

# modern
if (( $+commands[eza] )); then
    alias dir='eza -lbF --git'
    alias ls='eza --icons'
    alias l='eza -lagh --icons'
    alias la='eza -a --icons'
    alias ll='eza -lgh --icons'
    alias tree='eza -T --icons'
fi
if (( $+commands[ugrep] )); then
    alias uq='ug -Q'
    alias uz='ug -z'
    alias ux='ug -U --hexdump'
    alias ugit='ug -R --ignore-files'

    alias grep='ugrep -G'
    alias egrep='ugrep -E'
    alias fgrep='ugrep -F'
    alias zgrep='ugrep -zG'
    alias zegrep='ugrep -zE'
    alias zfgrep='ugrep -zF'

    alias xdump='ugrep -X ""'
    alias zmore='ugrep+ -z -I -+ --pager ""'
fi
if (( $+commands[rg] )); then
    alias rg='rg --column --colors="line:fg:yellow" --colors="path:fg:green" --colors="path:style:bold" --colors="match:style:bold"'
fi
if (( $+commands[win32yank] )); then
    alias c='win32yank -i'
    alias v='win32yank -o'
fi

# shell function
smart_alias au "ad_bundle"
smart_alias pf "proxy_off"
smart_alias pn "proxy_on"
smart_alias ui "update_cli"

# 带参数操作 (管道符使用单引号)
smart_alias cza "chezmoi apply"
smart_alias cze "chezmoi edit"
smart_alias czd "chezmoi cd"
smart_alias ep 'env | grep proxy'
smart_alias ez "exec zsh"
smart_alias gdf "git dft"
smart_alias in "ig --editor neovim"
smart_alias l "eza -lagh --icons"
smart_alias la "eza -a --icons"
smart_alias ll "eza -lgh --icons"
smart_alias nc "nvim --clean"
smart_alias pt "procs -t"
smart_alias zc "cd ~/.config/zsh && tree"
smart_alias zg "cd ~/.config/nvim/lua/gionvim && ls"

# long to short
smart_alias ac "aria2c"
smart_alias atr "autocorrect"
smart_alias cs "codespell"
smart_alias cz "chezmoi"
smart_alias lg "lazygit"
smart_alias hy "hexyl"
smart_alias hf "hyperfine"
smart_alias n "nvim" "nv"
smart_alias prt "print"

uc() {
    if [[ -z "$VCPKG_ROOT" ]]; then
        print -P "%F{160} Error: VCPKG_ROOT is not set. due direnv add directory?%f"
        return 1
    fi
    git -C "$VCPKG_ROOT" pull
}
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
