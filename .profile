. "$HOME/.cargo/env"

if [ $(pgrep xflux | wc -l) -lt 1 ]
then
  xflux -z 15217 -k 2000 > /dev/null
fi

export editor=usr/bin/nvim
echo "profile sourced"
