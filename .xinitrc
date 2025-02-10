#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
pactl info > /dev/null #makes sure pulse audio is working
sysmodmap=/etc/X11/xinit/.Xmodmap
xdg-settings set default-web-browser firefoxdeveloperedition.desktop
xdg-mime default firefoxdeveloperedition.desktop x-scheme-handler/http
xdg-mime default firefoxdeveloperedition.desktop x-scheme-handler/https

# merge in defaults and keymaps
# setting this first because otherwise it undoes the other ones.
setxkbmap -layout us -variant mac -option "terminate:ctrl_alt_bksp" -option "ctrl:nocaps"

if [ -f $sysresources ]; then

	xrdb -merge $sysresources

fi



if [ -f $sysmodmap ]; then
	xmodmap $sysmodmap
fi


if [ -f "$userresources" ]; then


	xrdb -merge "$userresources"

fi


if [ -f "$usermodmap" ]; then
	xmodmap "$usermodmap"
fi

export GTK_THEME=Qogir-Dark




# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
	for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

export QT_QPA_PLATFORMTHEME=qt5ct
# twm &
# xclock -geometry 50x50-1+1 &
# xterm -geometry 80x50+494+51 &
# xterm -geometry 80x20+494-0 &
# exec xterm -geometry 80x66+0+0 -name login

# setting redshift in i3
#if [ $(pgrep redshift | wc -l) -lt 1 ]
#then
#  redshift-gtk -l 40.44:-79.99 -t 6500:3000:
#fi

#xrandr --setprovideroutputsource modesetting NVIDIA-0
#xrandr --auto

xset dpms 1201 1205 1210
xset r rate 200 50
#nm-applet --sm-disable &
exec i3
