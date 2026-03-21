typeset -g -U path PATH

export PNPM_HOME="$HOME/.local/share/pnpm"
export VCPKG_ROOT="$HOME/.local/share/vcpkg"

local user_paths=(
    "$PNPM_HOME"
    "$HOME/.local/bin"
    "$VCPKG_ROOT"
)
for p in $user_paths; do
    [[ -d "$p" ]] && path=("$p" $path)
done

path=(
    /usr/local/bin
    /usr/bin
    /bin
    /usr/local/sbin
    $path
)

export PATH
