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

# Numlock
numlockx on &

# Keyboard delay
xset r rate 200 &

# Touchpad
xinput set-prop "SYNA309F:00 06CB:CD0B Touchpad" "libinput Tapping Enabled" 1 &
#xinput set-prop "SYNA309F:00 06CB:CD0B Touchpad" "libinput Click Method Enabled" 0 0 &

# Mouse pointer
#xsetroot -cursor_name left_ptr &

# Hangul input method
export GTK_IM_MODULE=nimf
export QT4_IM_MODULE="nimf"
export QT_IM_MODULE=nimf
export XMODIFIERS="@im=nimf"
nimf &

# Background image
nitrogen --random --set-zoom-fill &

# Emacs daemon
emacs --daemon &

# Volume OSD
volnoti &

# Dwm bar
$HOME/scripts/dwm-date.sh &

# Dwm
while true; do
    dwm >/dev/null 2>&1
done
