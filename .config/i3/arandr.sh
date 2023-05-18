#!/bin/sh

xrandr --auto
xrandr --output eDP-1-1 --primary --mode 1920x1080 --pos 0x0
feh --bg-fill $HOME/Pictures/Wallpapers/botw1.jpg

MONITOR_FOUND=`xrandr --listmonitors | grep -i DP-0`
if [ "$MONITOR_FOUND" != "" ]; then
    xrandr \
        --output DP-0 --primary --mode 3440x1440 --pos 0x0 \
        --output eDP-1-1 --mode 1920x1080 --pos 3440x0
    sleep 1
    xrandr \
        --output DP-0 --primary --mode 3440x1440 --pos 0x0 --rotate normal \
        --output eDP-1-1 --mode 1920x1080 --pos 2222x1440 --rotate normal
    sleep 1
    feh --bg-fill \
        $HOME/Pictures/Wallpapers/botw-widexcf.png \
        $HOME/Pictures/Wallpapers/botw1.jpg
fi

#source $HOME/.config/polybar/launch.sh
xfce4-panel --disable-wm-check &

source $HOME/.config/i3/tray-apps.sh

