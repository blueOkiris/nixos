# Configure i3

{ config, lib, pkgs, modulesPath, ... }:

{
    home-manager.users.dylan.home.file.".alternating_layouts.py".source =
        ../i3-alternating-layout/alternating_layouts.py;
    home-manager.users.dylan.xsession.windowManager.i3 = {
        enable = true;
        config = {
            floating.modifier = "Mod4";
            fonts = {
                names = [ "Ubuntu Mono" ];
                style = "Regular";
                size = 11.0;
            };
            gaps = {
                inner = 20;
                outer = 0;
                smartBorders = "on";
                smartGaps = true;
            };
            keybindings = {
                # Core functionality
                "Mod4+x" = "kill";
                "Mod4+Shift+c" = "reload";
                "Mod4+Shift+r" = "restart";
                "Mod4+Shift+e" = "exec i3-msg exitlscreen toggle";
                "Mod4+f" = "fullscreen";
                "Mod4+l" = "exec i3lock-fancy --nofork";

                # Audio
                "XF86AudioRaiseVolume" =
                    "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +5%";
                "XF86AudioLowerVolume" =
                    "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -5%";
                "XF86AudioMute" =
                    "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle";
                "XF86AudioMicMute" =
                    "exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle";

                # Applications
                "Mod4+Shift+s" = "exec --no-startup-id gnome-screenshot -i";
                "Mod4+Return" = "exec --no-startup-id alacritty";
                "Mod4+s" =
                    "exec \"rofi -modi drun,run -show drun -show-icons "
                        + "-icon-theme 'Papirus-Dark'\"";

                # Window management

                "Mod4+Up" = "focus up";
                "Mod4+Down" = "focus down";
                "Mod4+Left" = "focus left";
                "Mod4+Right" = "focus right";

                "Mod4+Shift+Up" = "move up";
                "Mod4+Shift+Down" = "move down";
                "Mod4+Shift+Left" = "move left";
                "Mod4+Shift+Right" = "move right";
                
                "Mod4+h" = "split h";
                "Mod4+v" = "split v";

                "Mod4+Control+s" = "layout stacking";
                "Mod4+w" = "layout tabbed";
                "Mod4+e" = "layout toggle split";
                
                "Mod4+Shift+space" = "floating toggle";
                "Mod4+space" = "focus mode_toggle";

                "Mod4+r" = "mode \"resize\"";

                # Workspaces

                "Mod4+1" = "workspace number \"1\"";
                "Mod4+2" = "workspace number \"2\"";
                "Mod4+3" = "workspace number \"3\"";
                "Mod4+4" = "workspace number \"4\"";
                "Mod4+5" = "workspace number \"5\"";
                "Mod4+6" = "workspace number \"6\"";
                "Mod4+7" = "workspace number \"7\"";
                "Mod4+8" = "workspace number \"8\"";
                "Mod4+9" = "workspace number \"9\"";

                "Mod4+Shift+1" = "move container to workspace number \"1\"";
                "Mod4+Shift+2" = "move container to workspace number \"2\"";
                "Mod4+Shift+3" = "move container to workspace number \"3\"";
                "Mod4+Shift+4" = "move container to workspace number \"4\"";
                "Mod4+Shift+5" = "move container to workspace number \"5\"";
                "Mod4+Shift+6" = "move container to workspace number \"6\"";
                "Mod4+Shift+7" = "move container to workspace number \"7\"";
                "Mod4+Shift+8" = "move container to workspace number \"8\"";
                "Mod4+Shift+9" = "move container to workspace number \"9\"";
            };
            modes = {
                resize = {
                    "Up" = "resize shrink height 5 px or 5 ppt";
                    "Down" = "resize grow height 5 px or 5 ppt";
                    "Left" = "resize shrink width 5 px or 5 ppt";
                    "Right" = "resize grow width 5 px or 5 ppt";

                    "Return" = "mode \"default\"";
                    "Escape" = "mode \"default\"";
                    "Mod4+r" = "mode \"default\"";
                };
            };
            window.commands = [
                {
                    command = "border pixel 5";
                    criteria = { class = ".*"; };
                }
            ];
            startup = [
                # Core
                {
                    command = "dex --autostart --environment i3";
                    always = false; notification = false;
                }

                # Lock screen
                {
                    command = "xss-lock --transfer-sleep-lock -- i3lock-fancy --nofork";
                    always = false; notification = false;
                }

                # Compose key
                {
                    command = "setxkbmap -option compose:ralt";
                    always = false; notification = false;
                }

                # Display stuff
                {
                    command =
                        "bash -c '"
                            + "if [ \"\$(xrandr --listmonitors | grep -i DP-0)\" ]; then "
                                + "feh --bg-fill "
                                    + "\$HOME/Pictures/Wallpapers/heros.png "
                                    + "\$HOME/Pictures/Wallpapers/ww-wave.jpg; "
                            + "else "
                                + "feh --bg-fill $HOME/Pictures/Wallpapers/ww-wave.jpg; "
                            + "fi"
                        + "'";
                    always = true; notification = false;
                }
                {
                    command = "xfce4-panel --disable-wm-check";
                    always = false; notification = true;
                }
                { command = "brightnessctl set 100%"; always = false; notification = false; }
                {
                    command = "python ~/.alternating_layouts.py";
                    always = true; notification = false;
                }

                # Unlock gnome keyring
                {
                    command = "dbus-update-activation-environment --all";
                    always = true; notification = false;
                }
                {
                    command = "gnome-keyring-daemon --start --components=ssh,secrets";
                    always = true; notification = false;
                }

                # Background/Hardware stuff
                { command = "xclip"; always = true; notification = false; }
                { command = "numlockx on"; always = true; notification = false; }
                {
                    command = "msi-perkeyrgb --model GE75 -p chakra";
                    always = false; notification = false;
                }

                # Tray apps
                { command = "nm-applet"; always = false; notification = false; }
                { command = "blueman-applet"; always = false; notification = false; }
                #{ command = "steam -silent"; always = false; notification = false; }
                { command = "nextcloud"; always = false; notification = false; }

                # Super key as Win+S
                {
                    command = "xcape -t 150 -e 'Super_L=Super_L|s'";
                    always = true; notification = false;
                }
            ];
            bars = [];
            modifier = "Mod4";
        };
    };
}

