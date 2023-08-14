if [ "${DESKTOP_SESSION}" = "gnome-wayland" ]; then
    export XCURSOR_SIZE=24
    export LIBVA_DRIVER_NAME=nvidia
    export XDG_SESSION_TYPE=wayland
    export GBM_BACKEND=nvidia
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export WLR_NO_HARDWARE_CURSORS=1
    export __NV_PRIME_RENDER_OFFLOAD=1
    export ENABLE_VKBASALT=1
    export QT_QPA_PLATFORMTHEME="wayland;xcb"
    export NIXOS_OZONE_WL=1
    export QT_QPA_PLATFORM=xcb
fi

