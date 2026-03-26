extract_logic() {
    if [[ $# -eq 0 ]]; then
        print -P "%F{yellow}󰋖 Usage:%f x <file1> <file2> ... [destination_dir]"
        return 1
    fi

    local files=()
    local dest="."

    if [[ $# -gt 1 ]]; then
        local last_arg="${@[-1]}"
        if [[ -d "$last_arg" ]]; then
            dest="$last_arg"
            files=("${@[1,-2]}")
        else
            files=("$@")
        fi
    else
        files=("$1")
    fi

    for file in "${files[@]}"; do
        if [[ ! -f "$file" ]]; then
            print -P "%F{red}󰅚 %f File %B%F{cyan}'$file'%f%b not found, skipping..."
            continue
        fi

        print -P "%F{blue}󰛒 %f Extracting %B%F{cyan}'$file'%f%b to %B%F{yellow}'$dest'%f%b..."

        if bsdtar -xpf "$file" -C "$dest"; then
            print -P "%F{244}[%D{%H:%M:%S}]%f %F{green}󰄬 %f %B$file%b Done"
        else
            print -P "%F{red}󰅚 %f Error: During extraction process of %B$file%b"
        fi
    done
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

local extract_cmds="x|extract|extract_logic"
local pack_cmds="p|pack|pack_logic"

zstyle ":completion:*:*:($extract_cmds):*:*" file-patterns \
    '*.tar(|.*):archives:压缩文件 *.zip:archives:压缩文件 *.7z:archives:archives:压缩文件 *.rar:archives:压缩文件 *.zst:archives:压缩文件' \
    '*(/):directories:目标目录' \
    '*:all-files:所有文件'
zstyle ":completion:*:*:($extract_cmds):*:*" tag-order 'archives' 'directories' 'all-files'


zstyle ":completion:*:*:($pack_cmds):*:*" file-patterns \
    '*(/):directories:文件夹 %p:all-files:所有文件'
zstyle ":completion:*:*:($pack_cmds):*:*" tag-order 'directories' 'all-files'
