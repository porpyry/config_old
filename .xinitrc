#!/bin/sh

sysresources=/etc/X11/xinit/.Xresources
if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

sysmodmap=/etc/X11/xinit/.Xmodmap
if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

userresources=$HOME/.Xresources
if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

usermodmap=$HOME/.Xmodmap
if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
  for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

numlockx on &
xset r rate 200 &
xinput set-prop "SYNA309F:00 06CB:CD0B Touchpad" "libinput Tapping Enabled" 1 &
xinput set-prop "SYNA309F:00 06CB:CD0B Touchpad" "libinput Click Method Enabled" 0 0 &

export GTK_IM_MODULE=nimf
export QT4_IM_MODULE="nimf"
export QT_IM_MODULE=nimf
export XMODIFIERS="@im=nimf"
nimf &

xsetroot -cursor_name left_ptr &

exec qtile start

#exec xmonad

#while true; do
#    dwm >/dev/null 2>&1
#done

#exec $HOME/.cache/xmonad/xmonad-x86_64-linux
