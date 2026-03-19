# PATH 管理（zsh 原生）

typeset -U path PATH   # 自动去重

export PNPM_HOME="$HOME/.local/share/pnpm"
export VCPKG_ROOT="$HOME/.local/share/vcpkg"

path=(
  $PNPM_HOME
  $HOME/.local/bin
  $VCPKG_ROOT
  $path
)
