. "$HOME/.cargo/env"

if [ $(pgrep xflux | wc -l) -lt 1 ]
then
  xflux -z 15217 -k 2000 > /dev/null
fi

xset r rate 200 25
alias j4-dmenu-desktop='j4-dmenu-desktop --dmenu="(cat ; (stest -flx $(echo $PATH | tr : ' ') | sort -u)) | dmenu"'

