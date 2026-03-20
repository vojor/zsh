#configuration alias
alias zshconfig='cd ~/.config/zsh && tree'
alias setproxy='export http_proxy="http://192.168.176.1:10810" && export https_proxy="http://192.168.176.1:10810"'
alias unsetproxy='unset http_proxy https_proxy'

## short replace long
alias pt='procs -t'
alias ign='ig --editor neovim'
alias n='nvim'
alias nc='nvim --clean'
alias lg='lazygit'
alias cs='codespell'
alias ac='aria2c'
alias ht='htop'
alias hy='hexyl'
alias hf='hyperfine'
alias hx='helix'
alias acr='autocorrect'
alias wh='whereis'

## shell command
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'

## replace GNU command
alias ls='eza'
alias l='eza -lagh --icons'
alias la='eza -a --icons'
alias ll='eza -lgh --icons'
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
