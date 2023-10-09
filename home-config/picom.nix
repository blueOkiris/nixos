# Configure picom using home-manager

{ config, lib, pkgs, modulesPath, ... }:

{
    home-manager.users.dylan.services.picom = {
        #enable = true;
        shadow = true;
        shadowExclude = [
            "name = 'Notification'"
            "class_g = 'Conky'"
            "class_g ?= 'Notify-osd'"
            "class_g = 'Cairo-clock'"
            "_GTK_FRAME_EXTENTS@:c"
        ];
        fade = true;
        fadeSteps = [
            0.03
            0.03
        ];
        inactiveOpacity = 0.9;
        opacityRules = [
            "100:name *= 'YouTube'"
            "100:name *= 'FreeTube'"
            "100:name *= 'Netflix'"
        ];
        vSync = true;
        wintypes = {
            tooltip = {
                fade = true; shadow = true; opacity = 0.75; focus = true; full-shadow = false;
            };
            dock = { shadow = false; clip-shadow-above = true; };
            dnd = { shadow = false; };
            popup_menu = { opacity = 0.8; };
            dropdown_menu = { opacity = 0.8; };
        };
        settings = {
            shadow-radius = 12;
            shadow-offset-x = -15;
            shadow-offset-y = -15;
            frame-opacity = 0.7;
            inactive-opacity-override = false;
            focus-exclude = [ "class_g = 'Cairo-clock'" ];
            corner-radius = 10;
            rounded-corners-exclude = [
                "window_type = 'dock'"
                "window_type = 'desktop'"
            ];
            blur-kern = "3x3box";
            blur-background-exclude = [
                "window_type = 'dock'"
                "window_type = 'desktop'"
                "_GTK_FRAME_EXTENTS@:c"
            ];
            backend = "glx";
            mark-wmwin-focused = true;
            mark-ovredir-focused = true;
            detect-rounded-corners = true;
            detect-client-opacity = true;
            detect-transient = true;
            use-damage = true;
            log-level = "warn";
        };
    };
}

