#configuration alias
alias zshconfig='cd ~/.config/zsh && tree'

## short replace long
alias au='antidote update'
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
