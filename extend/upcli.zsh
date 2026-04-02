register_cli() {
    local name=$1 repo=$2 cmd=$3 url=$4
    cli_apps_list+=("${name// /}|${repo// /}|${cmd// /}|${url// /}")
}
typeset -ga cli_apps_list
cli_apps_list=()
# "显示名称 | GitHub 仓库 | 本地命令 | 下载模板"
register_cli "autocorrect"   "huacnlee/autocorrect"        "autocorrect"   "https://github.com/huacnlee/autocorrect/releases/download/v{VER}/autocorrect-linux-musl-amd64.tar.gz"
register_cli "bashunit"      "TypedDevs/bashunit"          "bashunit"      "https://github.com/TypedDevs/bashunit/releases/download/{VER}/bashunit"
register_cli "checkmake"     "checkmake/checkmake"         "checkmake"     "https://github.com/checkmake/checkmake/releases/download/v{VER}/checkmake-v{VER}.linux.amd64"
register_cli "dotenv-linter" "dotenv-linter/dotenv-linter" "dotenv-linter" "https://github.com/dotenv-linter/dotenv-linter/releases/download/v{VER}/dotenv-linter-linux-x86_64.tar.gz"
register_cli "grpcurl"       "fullstorydev/grpcurl"        "grpcurl"       "https://github.com/fullstorydev/grpcurl/releases/download/v{VER}/grpcurl_{VER}_linux_x86_64.tar.gz"
register_cli "neocmakelsp"   "neocmakelsp/neocmakelsp"     "neocmakelsp"   "https://github.com/neocmakelsp/neocmakelsp/releases/download/v{VER}/neocmakelsp-x86_64-unknown-linux-musl.tar.gz"
register_cli "ltrs"          "jeertmans/languagetool-rust" "ltrs"          "https://github.com/jeertmans/languagetool-rust/releases/download/v{VER}/ltrs-v{VER}-x86_64-unknown-linux-musl.tar.gz"
register_cli "oxfmt"         "oxc-project/oxc"             "oxfmt"         "https://github.com/oxc-project/oxc/releases/download/apps_v{VER}/oxfmt-x86_64-unknown-linux-musl.tar.gz"
register_cli "oxlint"        "oxc-project/oxc"             "oxlint"        "https://github.com/oxc-project/oxc/releases/download/apps_v{VER}/oxlint-x86_64-unknown-linux-musl.tar.gz"

get_latest_version() {
    local repo="$1"
    local ver_regex='[0-9]+\.[0-9]+(\.[0-9]+)?(-[a-zA-Z0-9.]+)?'

    local final_url
    final_url=$(curl -sL -o /dev/null -w "%{url_effective}" \
                --connect-timeout 5 \
                --max-time 10 \
                --retry 2 \
                "https://github.com/${repo}/releases/latest" 2>/dev/null)
    [[ $? -ne 0 || -z "$final_url" ]] && return 1
    local tag="${final_url##*/}"
    local ver_tag=$(print -r -- "$tag" | grep -oE "$ver_regex" | head -n1)
    print -r -- "$ver_tag"
}

update_cli() {
    if [[ -z "$http_proxy" && -z "$HTTP_PROXY" ]]; then
        print -P -- "%F{244}[%D{%H:%M:%S}]%f %F{yellow}󰒄 检测到未开启代理，尝试启动代理配置...%f"
        (( $+functions[proxy_on] )) && proxy_on
    fi

    local ver_regex='[0-9]+\.[0-9]+(\.[0-9]+)?(-[a-zA-Z0-9.]+)?'

    if [[ "$1" == "all" ]]; then
        local old_opts=$(set +o | grep monitor)
        set +m

        local -i total=${#cli_apps_list[@]}
        local all_results_tmp=$(mktemp)
        trap 'command rm -f "$all_results_tmp"' EXIT INT TERM
        typeset -A remote_vers
        local max_jobs=5

        print -P -- "%F{magenta}󰑐 正在检查所有软件更新...%f"

        for i in {1..$total}; do
            while (( ${#jobstates} >= max_jobs )); do
                sleep 0.1
            done
            (
                local item="${cli_apps_list[$i]}"
                local repo="${${(@s/|/)item}[2]}"
                local r_ver=$(get_latest_version "$repo")
                print -r -- "$i:${r_ver:-fail}" >> "$all_results_tmp"
            ) &
        done

        wait
        eval "$old_opts"

        while IFS=: read -r idx v; do
            remote_vers[$idx]=$v
        done < "$all_results_tmp"
        command rm -f "$all_results_tmp"
        trap - EXIT INT TERM

        for j in {1..$total}; do
            local v=$remote_vers[$j]
            if [[ "$v" == "fail" || -z "$v" ]]; then
                local n="${${(@s/|/)cli_apps_list[$j]}[1]//[[:space:]]/}"
                print -P -- "\n%F{red}󰅚 %f%F{green}$n%f: %F{red}获取远程版本失败。%f"
            else
                update_cli $j "$v"
            fi
        done

        print -P -- "\n%F{green}✨ 所有程序检查完毕！%f"
        return 0
    fi

    local input_val="$1"
    local pre_fetched_ver=$2
    local target_idx=""

    if [[ -n "$input_val" ]]; then
        if [[ "$input_val" =~ ^[0-9]+$ ]]; then
            (( input_val >= 1 && input_val <= ${#cli_apps_list[@]} )) && target_idx=$input_val
        else
            for i in {1..${#cli_apps_list[@]}}; do
                [[ ${(L)${${(@s/|/)cli_apps_list[$i]}[1]//[[:space:]]/}} == ${(L)input_val} ]] && { target_idx=$i; break; }
            done
        fi
    fi

    if [[ -z "$target_idx" ]]; then
        print -P -- "\n%F{blue}󰋖 可用软件列表:%f"
        print -P -- "%F{240}──────────────────────────────%f"
        local i=1
        for item in $cli_apps_list; do
            local n="${${(@s/|/)item}[1]//[[:space:]]/}"
            local line=$(printf "  %2d)  %-15s" $i "$n")
            print -P -- "  %F{cyan}󱞩 ${line:2:4}%f${line:6}"
            ((i++))
        done
        print -P -- "%F{240}──────────────────────────────%f"
        print -P -- "%F{yellow}󱈸 用法:%f update_cli (别名:%F{cyan}ui%f) %F{green}[序号/名称/all]%f"
        return
    fi

    local raw_item="${cli_apps_list[$target_idx]}"
    local name repo cmd dl_tpl
    IFS='|' read -r name repo cmd dl_tpl <<< "$raw_item"

    print -P -- "\n%F{blue}󰚰 %f正在检查 %F{green}$name%f 的版本状态..."


    local local_ver="未安装"
    if (( $+commands[$cmd] )); then
        local cmd_output=$($cmd --version 2>&1 || $cmd -version 2>&1)
        local raw_local_ver=$(print "$cmd_output" | grep -oE "$ver_regex" | head -n1)
        local_ver=${raw_local_ver#v}
        [[ -z "$local_ver" ]] && local_ver="未知"
    fi

    local remote_ver=${pre_fetched_ver:-$(get_latest_version "$repo")}
    if [[ -z $remote_ver ]]; then
        remote_ver=$(get_latest_version "$repo")
    fi
    if [[ -z $remote_ver ]]; then
        print -P -- "%F{red}󰅚 错误：无法获取远程版本，请检查网络或代理。%f"
        return 1
    fi

    print -P -- "%F{244}󰓅 本地版本:%f ${local_ver} %F{yellow}󰁔%f %F{blue}最新版本:%f %F{cyan}$remote_ver%f"

    local need_update=1
    if [[ "$local_ver" != (未安装|未知) ]] && is-at-least "$remote_ver" "$local_ver"; then
        need_update=0
    fi
    if (( ! need_update )); then
        print -P -- "%F{green}󰄬 本地已是最新版本。%f"
        return 0
    fi

    print -P -- "%F{yellow}󰛒 发现新版本！%f"
    print -Pn -- "%F{cyan}󱈸 %f%F{244}是否自动更新? [y/N]: %f"
    read -k 1 res; print ""

    if [[ "$res" == "y" || "$res" == "Y" ]]; then
        local final_url=${dl_tpl//\{VER\}/$remote_ver}
        local tmp_dir=$(mktemp -d)
        local filename="${final_url##*/}"
        local target_path="$HOME/.local/bin/$cmd"

        print -P "🚀 %F{cyan}已确认更新，正在下载中...%f"
        local download_success=0
        if (( $+commands[aria2c] )); then
            aria2c -x 16 -s 16 -d "$tmp_dir" -o "$filename" "$final_url" && download_success=1
        elif (( $+commands[curl] )); then
            print -P "%F{yellow}󱑤 aria2c 未找到，切换至 curl...%f"
            curl -fLo "$tmp_dir/$filename" "$final_url" && download_success=1
        elif (( $+commands[wget] )); then
            print -P "%F{yellow}󱑤 aria2c/curl 未找到，切换至 wget...%f"
            wget -qO "$tmp_dir/$filename" "$final_url" && download_success=1
        fi
        if [[ $download_success -eq 1 ]]; then

            if [[ "$filename" =~ '\.(tar\.(gz|zst|bz2|xz)|tgz|zip|7z)$' ]]; then
                print -P "📦 %F{cyan}解压文件中...%f"
                if (( $+functions[extract_logic] )); then
                    extract_logic "$tmp_dir/$filename" "$tmp_dir" > /dev/null
                else
                    tar -xf "$tmp_dir/$filename" -C "$tmp_dir" 2>/dev/null || unzip -q "$tmp_dir/$filename" -d "$tmp_dir" 2>/dev/null
                fi
            fi

            local binary_path=""
            if (( $+commands[fd] )); then
                binary_path=$(fd -t f -H -I "^${cmd}$" "$tmp_dir" | head -n1)
            else
                binary_path=$(find "$tmp_dir" -type f -name "$cmd" | head -n1)
            fi
            if [[ -z "$binary_path" ]]; then
                if (( $+commands[fd] )); then
                    binary_path=$(fd -t f -H -I "${cmd}.*linux" "$tmp_dir" | head -n1)
                else
                    binary_path=$(find "$tmp_dir" -type f -executable -name "*${cmd}*linux*" | head -n1)
                fi
            fi
            if [[ -z "$binary_path" ]]; then
                binary_path=$(find "$tmp_dir" -type f -executable -name "*${cmd}*" | head -n1)
            fi

            if [[ -n $binary_path ]]; then
                local backup_success=0
                if [[ -f "$target_path" ]]; then
                    if command cp "$target_path" "${target_path}.bak" 2>/dev/null; then
                        backup_success=1
                    else
                        print -P -- "%F{yellow}󰀨 警告：%f备份旧版本失败，跳过本次更新以保安全。"
                        command rm -rf "$tmp_dir"; return 1
                    fi
                fi

                if command mv "$binary_path" "$target_path"; then
                    command chmod u+x "$target_path"

                    if "$target_path" --version &>/dev/null || "$target_path" -version &>/dev/null; then
                        print -P -- "%F{green}󰄬 $name %f更新成功！"
                        [[ $backup_success -eq 1 ]] && command rm -f "${target_path}.bak"
                    else
                        print -P -- "%F{yellow}󰀨 警告：%f新版本运行异常，正在执行回滚..."
                        if [[ $backup_success -eq 1 ]]; then
                             command mv "${target_path}.bak" "$target_path" && \
                             print -P -- "%F{green}󰄬 已成功回滚至旧版本。%f"
                        fi
                    fi
                fi
            else
                print -P -- "%F{red}󰅚 错误：%f包内未找到可执行文件 %F{green}'$cmd'%f"
                print -P -- "%F{yellow}󰚌 现场已保留: %f%F%U{blue}$tmp_dir%u%f"
                return 1
            fi
        else
            print -P -- "%F{red}󰅚 下载失败,未找到下载工具(aria2c/curl/wget)/下载格式不正确/网络错误。%f"
        fi
        [[ -d "$tmp_dir" ]] && command rm -rf "$tmp_dir"
    fi
}
