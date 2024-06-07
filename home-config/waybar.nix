# Configure waybar via home-manager

{ config, lib, pkgs, modulesPath, ... }:

{
    home-manager.users.dylan.programs.waybar = {
        enable = true;
        settings = {
            mainBar = {
                layer = "top";
                position = "top";
                height = 34;
                spacing = 0;
                fixed-center = true;

                modules-left = [
                    "image#rofi"
                    "image#thunar"
                    "image#firefox"
                    "image#tutanota"
                    "image#lutris"
                    "image#alacritty"
                    "wlr/taskbar"
                ];
                modules-center = [
                    "gamemode"
                    "clock"
                ];
                modules-right = [
                    "hyprland/workspaces"
                    "tray"
                    "pulseaudio"
                    "battery"
                    "disk"
                    "disk#home"
                    "disk#games"
                ];

                "image#rofi" = {
                    path = "/etc/nixos/distro-logos/nixos.svg";
                    size = 24;
                    on-click = "rofi -modi drun,run -show drun -show-icons -icon-theme 'Papirus-Dark'";
                };
                "image#thunar" = {
                    path = "/etc/nixos/home-config/icons/nautilus.svg";
                    size = 22;
                    on-click = "thunar";
                };
                "image#firefox" = {
                    path = "/etc/nixos/home-config/icons/firefox.svg";
                    size = 22;
                    on-click = "firefox";
                };
                "image#tutanota" = {
                    path = "/etc/nixos/home-config/icons/tutanota-desktop.svg";
                    size = 22;
                    on-click = "cd /home/dylan && tutanota";
                };
                "image#lutris" = {
                    path = "/etc/nixos/home-config/icons/lutris.svg";
                    size = 22;
                    on-click = "cd /home/dylan && lutris";
                };
                "image#alacritty" = {
                    path = "/etc/nixos/home-config/icons/terminal.svg";
                    size = 22;
                    on-click = "alacritty";
                };
                "wlr/taskbar" = {
                    format = "{icon} {name}";
                    icon-size = 20;
                    icon-theme = "Papirus-Dark";
                    tooltip-format = "{title}";
                    on-click = "activate";
                    all-outputs = true;
                };
                gamemode = {
                    format = "{glyph}";
                    format-alt = "{glyph} {count}";
                    glyph = "";
                    hide-not-running = true;
                    use-icon = true;
                    icon-name = "input-gaming-symbolic";
                    icon-spacing = 4;
                    icon-size = 20;
                    tooltip = true;
                    tooltip-format = "Games Running: {count}";
                };
                clock = {
                    interval = 1;
                    timezone = "US/Central";
                    format = "{:%a, %b %d %I:%M:%S%p}";
                    tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
                };
                "hyprland/workspaces" = {
                    disable-scroll = true;
                    all-outputs = true;
                    format = "{name}";
                    sort-by-number = true;
                };
                tray = {
                    icon-size = 20;
                    spacing = 12;
                };
                pulseaudio = {
                    format = "{volume}% {icon}";
                    format-bluetooth = "{volume}% {icon} ";
                    format-bluetooth-muted = "🔇 ";
                    format-muted = "🔇";
                    format-icons = {
                        headphone = "🎧";
                        hands-free = "";
                        headset = "";
                        phone = "";
                        portable = "";
                        car = "";
                        default = [
                            "🔊"
                        ];
                    };
                    on-click = "pavucontrol";
                };
                battery = {
                    interval = 60;
                    states = {
                        full = 95;
                        warning = 30;
                        critical = 15;
                    };
                    format = "{capacity}% {icon}";
                    format-charging = "^{capacity}% {icon}";
                    format-icons = [
                        ""
                        ""
                        ""
                        ""
                        ""
                    ];
                };
                disk = {
                    interval = 60;
                    format = "/ {free}";
                    path = "/";
                };
                "disk#home" = {
                    interval = 60;
                    format = "/home {free}";
                    path = "/home";
                };
                "disk#games" = {
                    interval = 60;
                    format = "/games {free}";
                    path = "/games";
                };
            };
        };
        style = ''
            * {
                /* `otf-font-awesome` is required to be installed for icons */
                font-family: Bitstream Vera Sans, FontAwesome, Ubuntu, Roboto, Helvetica, Arial, sans-serif;
                font-size: 16px;
            }

            #image.rofi {
                margin-left: 5px;
                margin-right: 10px;
            }
            #image.thunar {
                margin-right: 5px;
            }
            #image.firefox {
                margin-right: 5px;
            }
            #image.tutanota {
                margin-right: 5px;
            }
            #image.lutris {
                margin-right: 5px;
            }
            #image.alacritty {
                margin-right: 10px;
            }

            window#waybar {
                background-color: rgba(29, 30, 40, 0.8);
                /*border-bottom: 3px solid rgba(100, 114, 125, 0.5);*/
                color: #ffffff;
                transition-property: background-color;
                transition-duration: .5s;
            }

            window#waybar.hidden {
                opacity: 0.2;
            }

            /*
            window#waybar.empty {
                background-color: transparent;
            }
            window#waybar.solo {
                background-color: #FFFFFF;
            }
            */

            window#waybar.termite {
                background-color: #3F3F3F;
            }

            window#waybar.chromium {
                background-color: #000000;
                border: none;
            }

            button {
                /* Use box-shadow instead of border so the text isn't offset */
                box-shadow: inset 0 -3px transparent;
                /* Avoid rounded borders under each button name */
                border: none;
                border-radius: 0;
            }

            /*
             * https://github.com/Alexays/Waybar/wiki/
                 FAQ#the-workspace-buttons-have-a-strange-hover-effect
             */
            button:hover {
                background: inherit;
                box-shadow: inset 0 -3px #ffffff;
            }

            #workspaces button {
                padding: 0 5px;
                background-color: transparent;
                color: #ffffff;
            }

            #workspaces button:hover {
                background: rgba(0, 0, 0, 0.2);
            }

            #workspaces button.active {
                background-color: #64727D;
                box-shadow: inset 0 -3px #ffffff;
            }

            #workspaces button.urgent {
                background-color: #eb4d4b;
            }

            #mode {
                background-color: #64727D;
                border-bottom: 3px solid #ffffff;
            }

            #clock,
            #battery,
            #cpu,
            #memory,
            #disk,
            #temperature,
            #backlight,
            #network,
            #pulseaudio,
            #wireplumber,
            #custom-media,
            #tray,
            #mode,
            #idle_inhibitor,
            #scratchpad,
            #clock,
            #mpd {
                padding: 0 5px;
                color: #ffffff;
            }

            #window,
            #workspaces {
                margin: 0 5px;
            }

            #battery {
                padding-right: 10px;
            }
            #disk {
                padding-left: 0px;
            }

            /* If workspaces is the leftmost module, omit left margin */
            .modules-left > widget:first-child > #workspaces {
                margin-left: 0;
            }

            /* If workspaces is the rightmost module, omit right margin */
            .modules-right > widget:last-child > #workspaces {
                margin-right: 0;
            }

            /*#clock {
                background-color: #64727D;
            }

            #battery {
                background-color: #ffffff;
                color: #000000;
            }

            #battery.charging, #battery.plugged {
                color: #ffffff;
                background-color: #26A65B;
            }*/

            @keyframes blink {
                to {
                    background-color: #ffffff;
                    color: #000000;
                }
            }
            /*
            #battery.critical:not(.charging) {
                background-color: #f53c3c;
                color: #ffffff;
                animation-name: blink;
                animation-duration: 0.5s;
                animation-timing-function: linear;
                animation-iteration-count: infinite;
                animation-direction: alternate;
            }*/

            label:focus {
                background-color: #000000;
            }

            #cpu {
                background-color: #2ecc71;
                color: #000000;
            }

            #memory {
                background-color: #9b59b6;
            }
            /*
            #disk {
                background-color: #964B00;
            }
            */
            #backlight {
                background-color: #90b1b1;
            }

            #network {
                background-color: #2980b9;
            }

            #network.disconnected {
                background-color: #f53c3c;
            }

            /*#pulseaudio {
                background-color: #f1c40f;
                color: #000000;
            }

            #pulseaudio.muted {
                background-color: #90b1b1;
                color: #2a5c45;
            }*/

            #wireplumber {
                background-color: #fff0f5;
                color: #000000;
            }

            #wireplumber.muted {
                background-color: #f53c3c;
            }

            #custom-media {
                background-color: #66cc99;
                color: #2a5c45;
                min-width: 100px;
            }

            #custom-media.custom-spotify {
                background-color: #66cc99;
            }

            #custom-media.custom-vlc {
                background-color: #ffa000;
            }

            #temperature {
                background-color: #f0932b;
            }

            #temperature.critical {
                background-color: #eb4d4b;
            }
            /*
            #tray {
                background-color: #2980b9;
            }

            #tray > .passive {
                -gtk-icon-effect: dim;
            }

            #tray > .needs-attention {
                -gtk-icon-effect: highlight;
                background-color: #eb4d4b;
            }*/

            #idle_inhibitor {
                background-color: #2d3436;
            }

            #idle_inhibitor.activated {
                background-color: #ecf0f1;
                color: #2d3436;
            }

            #mpd {
                background-color: #66cc99;
                color: #2a5c45;
            }

            #mpd.disconnected {
                background-color: #f53c3c;
            }

            #mpd.stopped {
                background-color: #90b1b1;
            }

            #mpd.paused {
                background-color: #51a37a;
            }

            #language {
                background: #00b093;
                color: #740864;
                padding: 0 5px;
                margin: 0 5px;
                min-width: 16px;
            }

            #keyboard-state {
                background: #97e1ad;
                color: #000000;
                padding: 0 0px;
                margin: 0 5px;
                min-width: 16px;
            }

            #keyboard-state > label {
                padding: 0 5px;
            }

            #keyboard-state > label.locked {
                background: rgba(0, 0, 0, 0.2);
            }

            #scratchpad {
                background: rgba(0, 0, 0, 0.2);
            }

            #scratchpad.empty {
                background-color: transparent;
            }
        '';
    };
}

