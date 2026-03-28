proxy_on() {
    local proxy_host=""
    local proxy_port=""

    if grep -qi "microsoft" /proc/version 2>/dev/null; then
        proxy_port="10810"
        proxy_host=$(ip route show | grep default | awk '{print $3}')
    else
        proxy_port="10809"
        proxy_host="127.0.0.1"
    fi

    : ${proxy_host:=127.0.0.1}
    : ${proxy_port:=10809}

    local proxy_url="http://${proxy_host}:${proxy_port}"

    export {http,https,all}_proxy="$proxy_url"
    export {HTTP,HTTPS,ALL}_PROXY="$proxy_url"

    print -P "%F{244}[%D{%H:%M:%S}]%f %F{76}󱊟 %BProxy Success On:%b%f %F{32}${proxy_url}%f"
}

proxy_off() {
    unset http_proxy https_proxy all_proxy HTTP_PROXY HTTPS_PROXY ALL_PROXY
    print -P "%F{244}[%D{%H:%M:%S}]%f %F{202}󱊠 %BProxy Success Off%b%f"
}
