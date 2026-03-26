typeset -g -U path PATH

export TOOL_HOME="$HOME/.local/bin"
export PNPM_HOME="$HOME/.local/share/pnpm"

path=(
    "$TOOL_HOME"
    "$PNPM_HOME"
    "/usr/local/bin"
    "/usr/local/sbin"
    "/usr/bin"
    "/usr/sbin"
    $path
)

path=($^path(N-/))
