export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

export LANG=zh_CN.UTF-8
export LANGUAGE=zh_CN:en_US

export EDITOR='nvim'
export MANPAGER='nvim +Man! -'

export LESS='-R --mouse --wheel-lines=3'

if (( $+commands[fd] )); then
    export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --preview '[[ -f {} ]] && (bat --style=numbers --color=always {} || cat {}) | head -500'"

export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
