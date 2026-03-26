local fshtheme="$ZSH_CONFIG_DIR/utils/breeze.ini"

if (( $+functions[fast-theme] )); then
    if [[ -f "$fshtheme" ]]; then
        if ! fast-theme "$fshtheme" > /dev/null 2>&1; then
            print -P "%F{red}󰅚 %f %B%F{yellow}Warning:%f%b FSH theme %B%F{cyan}'$fshtheme'%f%b is invalid. Falling back to default."
            fast-theme default > /dev/null
        fi
    else
        print -P "%F{red}󰅚 %f %B%F{yellow}Warning:%f%b FSH theme file not found at %B%F{cyan}'$fshtheme'%f%b."
        fast-theme default > /dev/null
    fi
fi
