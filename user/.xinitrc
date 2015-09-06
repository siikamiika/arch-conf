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

if [ $(fgconsole) == "2" ]; then
    exec gnome-session
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
