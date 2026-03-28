update_cli() {
    if [[ -z "$http_proxy" && -z "$HTTP_PROXY" ]]; then
        print -P -- "%F{244}[%D{%H:%M:%S}]%f %F{yellow}󰒄 检测到未开启代理，正在自动配置...%f"
        proxy_on
    fi

    # 配置 (名称 | 仓库 | 本地命令 | 下载模板)
    # 模板版本部分使用 {VER} 占位符
    local apps=(
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

    if [[ "$1" == "all" ]]; then
        for i in {1..${#apps[@]}}; do
            update_cli $i;
        done
        return
    fi

    if [[ -z $1 || ! $1 =~ ^[0-9]+$ || $1 -gt ${#apps[@]} || $1 -lt 1 ]]; then
        print -P -- "%F{blue}󰋖 可用软件列表:%f"
        for i in {1..${#apps[@]}}; do
            local n=${${(s/|/)apps[$i]}[1]//[[:space:]]/}
            printf "%2d) %s\n" $i $n
        done
        print -P -- "\n%F{yellow}用法:%f update-cli(别名ui) [序号/all]"
        return
    fi

    local raw_item="${apps[$1]}"
    local selected=("${(@)${(@s/|/)raw_item}##[[:space:]]##}")
    selected=("${(@)selected%%[[:space:]]##}")
    local name=$selected[1] repo=$selected[2] cmd=$selected[3] dl_tpl=$selected[4]

    print -P -- "--- %F{blue}正在检查 $name 是否存在可用更新%f ---"

    local ver_regex='v?[0-9]+\.[0-9]+(\.[0-9]+)?(-[a-zA-Z0-9.]+)?'
    local raw_local_ver=$($cmd --version 2>&1 | grep -oE "$ver_regex" | head -n1)
    [[ -z "$raw_local_ver" ]] && raw_local_ver=$($cmd -version 2>&1 | grep -oE "$ver_regex" | head -n1)
    local local_ver=${raw_local_ver#v}

    local remote_url=$(curl -sI --connect-timeout 5 "https://github.com/$repo/releases/latest" | grep -i "location:" | tr -d '\r\n')
    local raw_remote_ver=$(echo "$remote_url" | grep -oE "$ver_regex" | head -n1)
    local remote_ver=${raw_remote_ver#v}

    if [[ -z $remote_ver ]]; then
        print -P -- "%F{red}󰅚 %f 错误：无法获取软件远程版本,请检查代理或仓库地址。"
        return
    fi

    print -P -- "本地版本: %F{242}${local_ver:-'未安装'}%f"
    print -P -- "最新版本: %F{cyan}$remote_ver%f"

    if [[ "$local_ver" == "$remote_ver" ]]; then
        print -P -- "%F{green}󰄬 %f 已是最新版本。"
    else
        print -P -- "%F{yellow}󰛒 %f 发现新版本！"
        print -Pn -- "是否自动下载并更新? [y/N]: "
        read -k 1 res; print ""

        if [[ "$res" == "y" || "$res" == "Y" ]]; then
            local final_url=${dl_tpl//\{VER\}/$remote_ver}
            local tmp_dir=$(mktemp -d)
            local filename="${final_url##*/}"

            print -P "🚀 %F{cyan}正在下载最新版本...%f"
            if aria2c -x 16 -s 16 -d "$tmp_dir" -o "$filename" "$final_url"; then

                if [[ "$filename" =~ '\.(tar\.(gz|zst|bz2|xz)|tgz|zip)$' ]]; then
                    print -P "📦 %F{cyan}检测到压缩格式，正在解压...%f"
                    extract_logic "$tmp_dir/$filename" "$tmp_dir" > /dev/null
                    \rm -f "$tmp_dir/$filename"
                else
                    print -P "📄 %F{cyan}检测到单文件二进制。%f"
                fi

                local binary_path=$(fd -t f -H -I "^${cmd}$" "$tmp_dir" | head -n1)
                [[ -z $binary_path ]] && binary_path=$(fd -t f -H -I "${cmd}.*linux" "$tmp_dir" | head -n1)
                [[ -z $binary_path ]] && binary_path=$(fd -t f -H -I "${cmd}" "$tmp_dir" | head -n1)

                if [[ -n $binary_path ]]; then
                    mv "$binary_path" "$HOME/.local/bin/$cmd"
                    chmod u+x "$HOME/.local/bin/$cmd"
                    print -P -- "%F{green}󰄬 %f $name 更新成功！"

                    print -P -- "%F{244}🧹 正在清理临时文件...%f"
                    \rm -rf "$tmp_dir"
                else
                    print -P -- "%F{red}󰅚 %f 错误：找不到文件 '$cmd'。"
                    print -P -- "%F{yellow}󰋖 失败现场已保留供检查：%f %U$tmp_dir%u"
                fi
            else
                print -P -- "%F{red}󰅚 %f 下载失败。"
                \rm -rf "$tmp_dir"
            fi
        fi
    fi
}
