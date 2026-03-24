extract_logic() {
    local file=$1
    local dest=${2:-.}

    [[ -f "$file" ]] || { print -P "%F{red}󰅚 %f File '$file' not found."; return 1 }
    [[ -d "$dest" ]] || mkdir -p "$dest"

    print -P "%F{blue}󰛒 %f Extracting '$file' to '$dest'..."
    bsdtar -xpf "$file" -C "$dest" && print -P "%F{244}[%D{%H:%M:%S}]%f %F{green}󰄬 %fExtracting Done."
}

pack_logic() {
    local target=$1
    shift
    local count=$#

    [[ -z "$target" || $count -eq 0 ]] && { print -P "%F{yellow}Usage:%f p <arch.ext> <files...>"; return 1 }

    if [[ -z "${target:e}" ]]; then
        target="${target}.tar.gz"
        print -P "%F{yellow} %BWarnin: No extension detected,using default set:%b%f %F{blue}%B$target%b%f"
    fi

    print -P "%F{blue}󰿖 %f Packing %B$count%b item(s) into '$target'..."
    bsdtar -acf "$target" "$@" && print -P "%F{244}[%D{%H:%M:%S}]%f %F{green}󰄬 %f Created."
}

(( $+commands[x] )) || alias x='extract_logic'
(( $+commands[p] )) || alias p='pack_logic'
alias extract='extract_logic'
alias pack='pack_logic'

if [[ -n "$compstate" || -n "$functions[compdef]" ]]; then
    local extract_cmds="(x|extract|extract_logic)"
    zstyle ":completion:*:*:${extract_cmds}:*:*" file-patterns \
        '*.tar(|.*):archives *.zip:archives *.7z:archives *.rar:archives *.zst:archives'
    zstyle ":completion:*:*:${extract_cmds}:*:*" group-name ''
    zstyle ":completion:*:*:${extract_cmds}:*:*" format '%F{blue}== %d ==%f'
    zstyle ":completion:*:*:${extract_cmds}:*:*" tag-order 'archives'

    zstyle ":completion:*:*:(p|pack|pack_logic):*:*" file-patterns \
        '*(/):directories %p:all-files'
fi
