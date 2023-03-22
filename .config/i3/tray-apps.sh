#!/bin/bash

# Author: Dylan Turner
# Description:
# - Need the status tray to exist, so if polybar is slow, we want to ensure things start correctly
# - i3 is asynchronous

nm-applet &
blueman-applet &
steam &
$HOME/Applications/nextcloud*.AppImage &
dunst &

