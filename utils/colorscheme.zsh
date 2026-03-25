local fshtheme="$ZSH_CONFIG_DIR/utils/fsh.ini"
if [[ -f "$fshtheme" ]] && (( $+functions[fast-theme] )); then
    fast-theme "$fshtheme" > /dev/null
fi
