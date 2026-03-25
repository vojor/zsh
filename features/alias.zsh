# core revise
alias sudo='sudo '
alias watch='watch '
alias time='time '
alias xargs='xargs '

# shell builtin
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv --preserve-root'
alias mkdir='mkdir -pv'
alias ez='exec zsh'

## replace GNU
alias dir='eza -lbF --git'
alias ls='eza --icons'
alias tree='eza -T --icons'

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

# 首选简写，备用简写 (可选),目标命令/函数
smart_alias() {
    local primary=$1
    local fallback=$2
    local target=$3

    if [[ -z "$target" ]]; then
        target="$fallback"
        fallback=""
    fi

    if (( ! $+commands[$primary] )); then
        alias $primary="$target"

    elif [[ -n "$fallback" ]] && (( ! $+commands[$fallback] )); then
        alias $fallback="$target"
        print -P "%F{244}󰋖 Note: '$primary' taken by $(command -v $primary), used '$fallback' instead.%f"

    else
        local reason="'$primary'"
        [[ -n "$fallback" ]] && reason="'$primary' and '$fallback'"
        print -P "%F{160} Warning: $reason taken! Please use original: %B$target%b%f"

        return 0
    fi
}

# 函数
smart_alias pn "proxy_on"
smart_alias pf "proxy_off"
smart_alias au "antidote-update"

# 带参数操作 (管道符使用单引号)
smart_alias zc 'cd ~/.config/zsh && tree'
smart_alias l "eza -lagh --icons"
smart_alias la "eza -a --icons"
smart_alias ll "eza -lgh --icons"
smart_alias pt "procs -t"
smart_alias ign "ig --editor neovim"
smart_alias nc "nvim --clean"

# long to short
smart_alias n vi "nvim"
smart_alias lg "lazygit"
smart_alias cs "codespell"
smart_alias ac "aria2c"
smart_alias ht "htop"
smart_alias hy "hexyl"
smart_alias hf "hyperfine"
smart_alias atr "autocorrect"
