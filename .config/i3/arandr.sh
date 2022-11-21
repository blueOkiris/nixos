#!/bin/sh

xrandr --auto
xrandr --output eDP-1-1 --primary --mode 1920x1080 --pos 0x0
feh --bg-fill $HOME/Pictures/Wallpapers/botw1.jpg

MONITOR_FOUND=`xrandr --listmonitors | grep -i DP-0`
if [ "$MONITOR_FOUND" != "" ]; then
    xrandr --output DP-0 --primary --mode 3440x1440 --pos 0x0 --output eDP-1-1 --mode 1920x1080 --pos 3440x0
    sleep 2
    xrandr --output DP-0 --primary --mode 3440x1440 --pos 0x0 --rotate normal --output DP-1 --off --output HDMI-0 --off --output DP-2 --off --output DP-3 --off --output DP-4 --off --output eDP-1-1 --mode 1920x1080 --pos 3440x1208 --rotate normal --output DP-1-1 --off --output DP-1-2 --off
    sleep 2
    feh --bg-fill $HOME/Pictures/Wallpapers/botw-widexcf.png $HOME/Pictures/Wallpapers/botw1.jpg
fi

source $HOME/.config/polybar/launch.sh

