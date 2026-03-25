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

local extract_cmds="x|extract|extract_logic"
local pack_cmds="p|pack|pack_logic"

zstyle ":completion:*:*:($extract_cmds):*:*" file-patterns \
    '*.tar(|.*):archives:压缩文件 *.zip:archives:压缩文件 *.7z:archives:压缩文件 *.rar:archives:压缩文件 *.zst:archives:压缩文件' \
    '*:all-files:所有文件'
zstyle ":completion:*:*:($extract_cmds):*:*" tag-order 'archives' 'all-files'

zstyle ":completion:*:*:($pack_cmds):*:*" file-patterns \
    '*(/):directories:文件夹 %p:all-files:所有文件'
zstyle ":completion:*:*:($pack_cmds):*:*" tag-order 'directories' 'all-files'


extract_logic() {
    # 如果没有参数，显示用法
    if [[ $# -eq 0 ]]; then
        print -P "%F{yellow}󰋖 Usage:%f x <file1> <file2> ... [destination_dir]"
        return 1
    fi

    local files=()
    local dest="."
    
    # 逻辑判断：如果参数大于1，且最后一个参数是目录，则将其设为 dest
    if [[ $# -gt 1 ]]; then
        local last_arg="${@[-1]}"
        if [[ -d "$last_arg" ]]; then
            dest="$last_arg"
            # 将除最后一个参数外的所有参数存入待解压列表
            files=("${@[1,-2]}")
        else
            files=("$@")
        fi
    else
        files=("$1")
    fi

    # 开始循环处理文件
    for file in "${files[@]}"; do
        # 检查文件是否存在
        if [[ ! -f "$file" ]]; then
            print -P "%F{red}󰅚 %f File %B%F{cyan}'$file'%f%b not found, skipping..."
            continue
        fi

        print -P "%F{blue}󰛒 %f Extracting %B%F{cyan}'$file'%f%b to %B%F{yellow}'$dest'%f%b..."

        # 使用 bsdtar 执行解压
        # -x: 解压, -p: 保留权限, -f: 指定文件, -C: 指定目录
        if bsdtar -xpf "$file" -C "$dest"; then
            print -P "%F{244}[%D{%H:%M:%S}]%f %F{green}󰄬 %f %B$file%b Done"
        else
            print -P "%F{red}󰅚 %f Error: During extraction process of %B$file%b"
        fi
    done
}


# 修改 file-patterns，去掉特殊的过滤限制，或者允许重复触发
zstyle ":completion:*:*:($extract_cmds):*:*" file-patterns \
    '*.tar(|.*):archives:压缩文件 *.zip:archives:压缩文件 *.7z:archives:压缩文件 *.rar:archives:压缩文件 *.zst:archives:压缩文件' \
    '*(/):directories:目标目录' \
    '*:all-files:所有文件'

