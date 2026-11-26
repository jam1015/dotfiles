export WM=i3
typeset -U path  # Ensure unique entries in PATH
path=(
  $HOME/.local/bin
  $HOME/.npm-global/bin
  $path
  $HOME/.cargo/bin
)
export PATH
