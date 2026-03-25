extract_logic() {
    local file=$1
    local dest=${2:-.}

    [[ -f "$file" ]] || { print -P "%F{red}󰅚 %f File '$file' not found."; return 1 }
    [[ -d "$dest" ]] || mkdir -p "$dest"

    print -P "%F{blue}󰛒 %f Extracting %B%F{cyan}'$file'%f%b to %B%F{yellow}'$dest'%f%b..."

    if bsdtar -xpf "$file" -C "$dest"; then
        print -P "%F{244}[%D{%H:%M:%S}]%f %F{green}󰄬 %f Extracting Done"
    else
        print -P "%F{red}󰅚 %f Error:During extraction process."
        return 1
    fi
}

pack_logic() {
    local target=$1
    shift
    local count=$#

    if [[ -z "$target" || $count -eq 0 ]]; then
        print -P "%F{yellow}󰋖 Usage:%f p <filename.ext> <files...>"
        return 1
    fi

    if [[ -z "${target:e}" ]]; then
        target="${target}.tar.gz"
        print -P "%F{yellow} %BWarnin: No extension detected,using default set:%b%f %F{blue}%B$target%b%f"
    fi

    print -P "%F{blue}󰿖 %f Packing %B%F{magenta}$count%f%b item(s) into %B%F{cyan}'$target'%f%b..."

    if bsdtar -acf "$target" "$@"; then
        print -P "%F{244}[%D{%H:%M:%S}]%f %F{green}󰄬 %f Created Packaging"
    else
        print -P "%F{red}󰅚 %f Packaging Failed"
        return 1
    fi
}

(( $+commands[x] )) || alias x='extract_logic'
(( $+commands[p] )) || alias p='pack_logic'
alias extract='extract_logic'
alias pack='pack_logic'

if [[ -n "$compstate" || -n "$functions[compdef]" ]]; then
    local extract_cmds="x|extract|extract_logic"
    local pack_cmds="p|pack|pack_logic"

    zstyle ":completion:*:*:($extract_cmds):*:*" file-patterns \
        '*.tar(|.*):archives *.zip:archives *.7z:archives *.rar:archives *.zst:archives'
    zstyle ":completion:*:*:($pack_cmds):*:*" file-patterns \
        '*(/):directories %p:all-files'

    zstyle ":completion:*:*:($extract_cmds|$pack_cmds):*:*" group-name ''
    zstyle ":completion:*:*:($extract_cmds|$pack_cmds):*:*" format '%F{blue}== %d ==%f'
    zstyle ":completion:*:*:($extract_cmds|$pack_cmds):*:*" tag-order 'archives'
fi
