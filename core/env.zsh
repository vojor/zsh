export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

export LANG=zh_CN.UTF-8
export LANGUAGE=zh_CN:en_US
export LC_ALL=zh_CN.UTF-8

export EDITOR='nvim'
export MANPAGER='nvim +Man! -'

export LESS='-R --mouse --wheel-lines=3'
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

if (( $+commands[fd] )); then
    export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

local preview_cmd='[[ -d {} ]] && eza --tree --color=always {} | head -200 || (bat --style=numbers --color=always {} || cat {}) 2>/dev/null | head -500'
export FZF_DEFAULT_OPTS="--height 45% --layout=reverse --border --preview '$preview_cmd'"
