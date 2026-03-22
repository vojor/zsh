proxy_on() {
    export http_proxy="http://192.168.176.1:10810"
    export https_proxy="http://192.168.176.1:10810"
    export all_proxy="http://192.168.176.1:10810"
    print -P "%F{244}[%D{%H:%M:%S}]%f %F{green}%BSuccess:%b%f %F{blue}Proxy On.%f"
}

proxy_off() {
    unset http_proxy https_proxy all_proxy
    print -P "%F{244}[%D{%H:%M:%S}]%f %F{green}%BSuccess:%b%f %F{red}Proxy Off.%f"
}
