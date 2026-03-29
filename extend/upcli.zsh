# 格式："显示名称 | GitHub 仓库 | 本地命令 | 下载模板"
typeset -ga cli_apps_list
cli_apps_list=(
    "autocorrect  | huacnlee/autocorrect        | autocorrect   | https://github.com/huacnlee/autocorrect/releases/download/v{VER}/autocorrect-linux-musl-amd64.tar.gz"
    "bashunit     | TypedDevs/bashunit          | bashunit      | https://github.com/TypedDevs/bashunit/releases/download/{VER}/bashunit"
    "checkmake    | checkmake/checkmake         | checkmake     | https://github.com/checkmake/checkmake/releases/download/v{VER}/checkmake-v{VER}.linux.amd64"
    "dotenv-linter| dotenv-linter/dotenv-linter | dotenv-linter  | https://github.com/dotenv-linter/dotenv-linter/releases/download/v{VER}/dotenv-linter-linux-x86_64.tar.gz"
    "grpcurl      | fullstorydev/grpcurl        | grpcurl       | https://github.com/fullstorydev/grpcurl/releases/download/v{VER}/grpcurl_{VER}_linux_x86_64.tar.gz"
    "neocmakelsp  | neocmakelsp/neocmakelsp     | neocmakelsp   | https://github.com/neocmakelsp/neocmakelsp/releases/download/v{VER}/neocmakelsp-x86_64-unknown-linux-musl.tar.gz"
    "ltrs         | jeertmans/languagetool-rust | ltrs          | https://github.com/jeertmans/languagetool-rust/releases/download/v{VER}/ltrs-v{VER}-x86_64-unknown-linux-musl.tar.gz"
    "oxfmt        | oxc-project/oxc             | oxfmt         | https://github.com/oxc-project/oxc/releases/download/apps_v{VER}/oxfmt-x86_64-unknown-linux-musl.tar.gz"
    "oxlint       | oxc-project/oxc             | oxlint        | https://github.com/oxc-project/oxc/releases/download/apps_v{VER}/oxlint-x86_64-unknown-linux-musl.tar.gz"
)

update_cli() {
    if [[ -z "$http_proxy" && -z "$HTTP_PROXY" ]]; then
        print -P -- "%F{244}[%D{%H:%M:%S}]%f %F{yellow}󰒄 检测到未开启代理，尝试调用 proxy_on...%f"
        (( $+functions[proxy_on] )) && proxy_on
    fi

    if [[ "$1" == "all" ]]; then
        print -P -- "%F{magenta}󰑐 正在并行检查所有软件更新...%f"
        typeset -A remote_vers
        local tmp_file=$(mktemp)
        for i in {1..${#cli_apps_list[@]}}; do
            (
                local item="${cli_apps_list[$i]}"
                local repo="${${(@s/|/)item}[2]//[[:space:]]/}"
                local ver_regex='[0-9]+\.[0-9]+(\.[0-9]+)?(-[a-zA-Z0-9.]+)?'

                local r_ver=$(curl -sIL --connect-timeout 5 "https://github.com/$repo/releases/latest" | \
                               grep -i "location:" | grep -oE "$ver_regex" | head -n1 | tr -d 'v')
                print -r -- "$i:$r_ver" >> "$tmp_file"
            ) &
        done

        wait

        while IFS=: read -r idx v; do
            remote_vers[$idx]=$v
        done < "$tmp_file"
        \rm -f "$tmp_file"

        for i in {1..${#cli_apps_list[@]}}; do
            update_cli $i ${remote_vers[$i]}
        done
        return
    fi

    local input_val="$1"
    local pre_fetched_ver=$2
    local target_idx=""

    if [[ -n "$input_val" ]]; then
        if [[ "$input_val" =~ ^[0-9]+$ ]]; then
            if [[ "$input_val" -ge 1 && "$input_val" -le ${#cli_apps_list[@]} ]]; then
                target_idx=$input_val
            fi
        else
            for i in {1..${#cli_apps_list[@]}}; do
                local app_name="${${(@s/|/)cli_apps_list[$i]}[1]//[[:space:]]/}"
                if [[ "${(L)app_name}" == "${(L)input_val}" ]]; then
                    target_idx=$i
                    break
                fi
            done
        fi
    fi

    if [[ -z "$target_idx" ]]; then
        print -P -- "\n%F{blue}󰋖 可用软件列表:%f"
        print -P -- "%F{240}──────────────────────────────%f"
        local i=1
        for item in $cli_apps_list; do
            local n="${${(@s/|/)item}[1]//[[:space:]]/}"
            printf "  %F{cyan}%2d)%f  %-15s\n" $i "$n"
            ((i++))
        done
        print -P -- "%F{240}──────────────────────────────%f"
        print -P -- "%F{yellow}用法:%f update_cli %F{green}[序号 / 名称 / all]%f"
        return
    fi

    local raw_item="${cli_apps_list[$target_idx]}"
    local selected=("${(@)${(@s/|/)raw_item}##[[:space:]]##}")
    selected=("${(@)selected%%[[:space:]]##}")
    local name=$selected[1] repo=$selected[2] cmd=$selected[3] dl_tpl=$selected[4]

    print -P -- "\n%F{blue}󰚰 %f正在检查 %F{white}$name%f 的版本状态..."

    local ver_regex='[0-9]+\.[0-9]+(\.[0-9]+)?(-[a-zA-Z0-9.]+)?'
    local raw_local_ver=$($cmd --version 2>&1 | grep -oE "$ver_regex" | head -n1)
    [[ -z "$raw_local_ver" ]] && raw_local_ver=$($cmd -version 2>&1 | grep -oE "$ver_regex" | head -n1)
    local local_ver=${raw_local_ver#v}

    local remote_ver=$pre_fetched_ver
    if [[ -z $remote_ver ]]; then
        remote_ver=$(curl -sIL --connect-timeout 5 "https://github.com/$repo/releases/latest" | \
                       grep -i "location:" | grep -oE "$ver_regex" | head -n1 | tr -d 'v')
    fi

    if [[ -z $remote_ver ]]; then
        print -P -- "%F{red}󰅚 错误：无法获取远程版本，请检查网络或代理。%f"
        return 1
    fi

    print -P -- "%F{244}  本地:%f ${local_ver:-'未安装'} %F{244}󰁔 最新:%f %F{cyan}$remote_ver%f"

    if [[ "$local_ver" == "$remote_ver" ]]; then
        print -P -- "%F{green}󰄬 已是最新版本。%f"
        return 0
    fi

    print -P -- "%F{yellow}󰛒 发现新版本！%f"
    print -Pn -- "%F{244}  是否自动更新? [y/N]: %f"
    read -k 1 res; print ""

    if [[ "$res" == "y" || "$res" == "Y" ]]; then
        local final_url=${dl_tpl//\{VER\}/$remote_ver}
        local tmp_dir=$(mktemp -d)
        local filename="${final_url##*/}"
        local target_path="$HOME/.local/bin/$cmd"

        print -P "🚀 %F{cyan}下载中...%f"
        if aria2c -x 16 -s 16 -d "$tmp_dir" -o "$filename" "$final_url"; then

            if [[ "$filename" =~ '\.(tar\.(gz|zst|bz2|xz)|tgz|zip|7z)$' ]]; then
                print -P "📦 %F{cyan}解压文件中...%f"
                if (( $+functions[extract_logic] )); then
                    extract_logic "$tmp_dir/$filename" "$tmp_dir" > /dev/null
                else
                    tar -xf "$tmp_dir/$filename" -C "$tmp_dir" 2>/dev/null || unzip -q "$tmp_dir/$filename" -d "$tmp_dir" 2>/dev/null
                fi
            fi

            local binary_path=$(fd -t f -x -H -I "^${cmd}$" "$tmp_dir" | head -n1)
            [[ -z $binary_path ]] && binary_path=$(fd -t f -x -H -I "${cmd}.*linux" "$tmp_dir" | head -n1)

            if [[ -n $binary_path ]]; then
                [[ -f "$target_path" ]] && cp "$target_path" "${target_path}.bak"

                if mv "$binary_path" "$target_path"; then
                    chmod u+x "$target_path"
                    if "$target_path" --version &>/dev/null || "$target_path" -version &>/dev/null; then
                        print -P -- "%F{green}󰄬 $name 更新成功！%f"
                        \rm -f "${target_path}.bak"
                    else
                        print -P -- "%F{red}󰅚 警告：新版二进制运行异常，已执行回滚。%f"
                        mv "${target_path}.bak" "$target_path"
                    fi
                fi
                \rm -rf "$tmp_dir"
            else
                print -P -- "%F{red}󰅚 错误：包内未找到可执行文件 '$cmd'%f"
                print -P -- "%F{yellow}现场已保留: %u$tmp_dir%u%f"
            fi
        else
            print -P -- "%F{red}󰅚 下载失败。%f"
            \rm -rf "$tmp_dir"
        fi
    fi
}
