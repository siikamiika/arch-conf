#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

### xbindkeys
xbindkeys &

### python-clipmenu
#python-clipmenu-daemon &

### fcitx
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
fcitx -d &

### wacom
xsetwacom --set "Wacom Intuos S Pen stylus" Area 0 0 15200 8550
xsetwacom --set "Wacom Intuos S Pen stylus" MapToOutput "eDP1"

if [ $(fgconsole) == "2" ]; then
    exec gnome-session
elif [ $(fgconsole) == "3" ]; then
    exec compton --config ~/.compton.conf -b &
    exec icewm-session
else
    exec compton --config ~/.compton.conf -b &
    feh --bg-scale ~/Pictures/black.png
    exec i3
fi

#exec gnome-session
#exec gnome-session --session=i3
#exec i3
#export KDEWM=/usr/bin/i3
#exec startkde
