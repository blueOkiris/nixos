#!/bin/sh

BIG_WALL="$HOME/Pictures/Wallpapers/heros.png"
SMALL_WALL="$HOME/Pictures/Wallpapers/ww-wave.jpg"

BIG_MONITOR="DP-1-0"
BIG_MONITOR_RES="3440x1440"
SMALL_MONITOR="eDP-1"
SMALL_MONITOR_RES="1920x1080"
SMALL_MONITOR_OFFSET="2222x1440"

xrandr --auto
xrandr --output ${SMALL_MONITOR} --primary --mode ${SMALL_MONITOR_RES} --pos 0x0
feh --bg-fill ${SMALL_WALL}

MONITOR_FOUND=`xrandr --listmonitors | grep -i ${BIG_MONITOR}`
if [ "${MONITOR_FOUND}" != "" ]; then
    xrandr \
        --output ${BIG_MONITOR} --primary --mode ${BIG_MONITOR_RES} --pos 0x0 \
        --output ${SMALL_MONITOR} --mode ${SMALL_MONITOR_RES} --pos 3440x0
    sleep 1
    xrandr \
        --output ${BIG_MONITOR} --primary --mode ${BIG_MONITOR_RES} --pos 0x0 --rotate normal \
        --output ${SMALL_MONITOR} --mode ${SMALL_MONITOR_RES} \
            --pos ${SMALL_MONITOR_OFFSET} --rotate normal
    sleep 1
    feh --bg-fill ${BIG_WALL} ${SMALL_WALL}
fi

#source $HOME/.config/polybar/launch.sh
xfce4-panel --disable-wm-check &

source $HOME/.config/i3/tray-apps.sh

