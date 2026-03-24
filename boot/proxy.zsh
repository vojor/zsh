proxy_on() {
    local proxy_host=""
    local proxy_port="10810"

    if [[ "$OSTYPE" == "darwin"* ]]; then
        proxy_host="127.0.0.1"
    elif grep -qi "microsoft" /proc/version 2>/dev/null; then
        proxy_host=$(ip route show | grep default | awk '{print $3}')
    else
        proxy_host=$(ip route show | grep default | awk '{print $3}')
        [[ -z "$proxy_host" ]] && proxy_host="127.0.0.1"
    fi

    : ${proxy_host:=127.0.0.1}

    local proxy_url="http://${proxy_host}:${proxy_port}"

    export http_proxy="$proxy_url"
    export https_proxy="$proxy_url"
    export all_proxy="$proxy_url"
    export HTTP_PROXY="$proxy_url"
    export HTTPS_PROXY="$proxy_url"
    export ALL_PROXY="$proxy_url"

    print -P "%F{244}[%D{%H:%M:%S}]%f %F{76}󱊟 %BProxy Success On:%b%f %F{32}${proxy_url}%f"
}

proxy_off() {
    unset http_proxy https_proxy all_proxy HTTP_PROXY HTTPS_PROXY ALL_PROXY
    print -P "%F{244}[%D{%H:%M:%S}]%f %F{202}󱊠 %BProxy Success Off%b%f"
}
