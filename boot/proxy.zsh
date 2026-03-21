proxy_on() {
    export http_proxy="http://192.168.176.1:10810"
    export https_proxy="http://192.168.176.1:10810"
    export all_proxy="http://192.168.176.1:10810"
    echo "Proxy success on"
}

proxy_off() {
    unset http_proxy https_proxy all_proxy
    echo "Proxy success off"
}
