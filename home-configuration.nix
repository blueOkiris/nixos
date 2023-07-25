# Home folder configuration for user "dylan"

{ config, lib, pkgs, modulesPath, ... }:

{
    imports = [ <home-manager/nixos> ];
    home-manager.useGlobalPkgs = true;
    home-manager.users.dylan = { pkgs, ... }: {
        home.stateVersion = "23.05";
        home.packages = [ ];
        programs.alacritty = {
            enable = true;
            settings = {
                env = {
                    TERM = "alacritty";
                    LANG = "en_US.UTF-8";
                    LC_CTYPE = "en_US.UTF-8";
                };
                font = {
                    normal = {
                        family = "Ubuntu Mono";
                        style = "Regular";
                    };
                    size = 12;
                };
                colors = { # Based on Dracula, but with a better blue
                    primary = {
                        background = "#282a37";
                        foreground = "#f8f8f2";
                        bright_foreground = "#ffffff";
                    };
                    cursor = {
                        text = "CellBackground";
                        cursor = "CellForeground";
                    };
                    vi_mode_cursor = {
                        text = "CellBackground";
                        cursor = "CellForeground";
                    };
                    search = {
                        matches = {
                            foreground = "#44475a";
                            background = "#50fa7b";
                        };
                        focused_match = {
                            foreground = "#44475a";
                            background = "#ffb86c";
                        };
                        footer_bar = {
                            foreground = "#f8f8f2";
                            background = "#282a36";
                        };
                    };
                    hints = {
                        start = {
                            foreground = "#282a36";
                            background = "#f1fa8c";
                        };
                        end = {
                            foreground = "#f1fa8c";
                            background = "#282a36";
                        };
                    };
                    selection = {
                        text = "CellForeground";
                        background = "#44475a";
                    };
                    normal = {
                        black = "#21222c";
                        red = "#ff5555";
                        green = "#50fa7b";
                        yellow = "#f1fa8c";
                        blue = "#0066cf";
                        magenta = "#ff79c6";
                        cyan = "#8be9fd";
                        white = "#f8f8f2";
                    };
                    bright = {
                        black = "#6272a4";
                        red = "#ff6e6e";
                        green = "#69ff94";
                        yellow = "#ffffa4";
                        blue = "#1177ff";
                        magenta = "#ff92df";
                        cyan = "#a4ffff";
                        white = "#ffffff";
                    };
                };
            };
        };
        services.dunst = {
            enable = true;
            settings = {
                global = {
                    frame_width = 5;
                    icon_theme = "Papirus-Dark";
                };
                urgency_low = {
                    background = "#282a36";
                    foreground = "#f8f8f2";
                };
                urgency_normal = {
                    background = "#282a36";
                    foreground = "#f8f8f2";
                };
            };
        };
        gtk = {
            enable = true;
            theme.name = "Arc-Dark";
            iconTheme.name = "Papirus-Dark";
            cursorTheme.name = "breeze_cursors";
        };
        home.file.".config/hypr/hyprland.conf".source = .config/hypr/hyprland.conf;
        home.file.".config/hypr/hyprpaper.conf".source = .config/hypr/hyprpaper.conf;
        xsession.windowManager.i3 = {
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
                        command = "\$HOME/i3-alternating-layout/alternating_layouts.py";
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
                    { command = "steam -silent"; always = false; notification = false; }
                    { command = "nextcloud"; always = false; notification = false; }
                ];
                bars = [];
                modifier = "Mod4";
            };
        };
        services.picom = {
            enable = true;
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
        programs.waybar = {
            enable = true;
            settings = {
                mainBar = {
                    layer = "top";
                    position = "top";
                    height = 34;
                    spacing = 0;
                    fixed-center = true;

                    modules-left = [
                        "wlr/workspaces"
                        "wlr/taskbar"
                    ];
                    modules-center = [
                        "gamemode"
                        "clock"
                    ];
                    modules-right = [
                        "tray"
                        "pulseaudio"
                        "battery"
                        "disk"
                        "disk#home"
                        "disk#games"
                    ];

                    "wlr/workspaces" = {
                        disable-scroll = true;
                        all-outputs = true;
                        format = "{name}";
                        sort-by-number = true;
                    };
                    "wlr/taskbar" = {
                        format = "{icon} {name}";
                        icon-size = 14;
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
                        format = "{:%A, %B %d %X}";
                        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
                    };
                    tray = {
                        spacing = 12;
                    };
                    pulseaudio = {
                        format = "{volume}% {icon} {format_source} ";
                        format-bluetooth = "{volume}% {icon}  {format_source}";
                        format-bluetooth-muted = "  {format_source}";
                        format-muted = " {format_source}";
                        format-source = "{volume}% ";
                        format-source-muted = "";
                        format-icons = {
                            headphone = "";
                            hands-free = "";
                            headset = "";
                            phone = "";
                            portable = "";
                            car = "";
                            default = [
                                ""
                                ""
                                ""
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
                        format = "Root: {percentage_used}%";
                        path = "/";
                    };
                    "disk#home" = {
                        interval = 60;
                        format = "Home: {percentage_used}%";
                        path = "/home";
                    };
                    "disk#games" = {
                        interval = 60;
                        format = "Games: {percentage_used}%";
                        path = "/games";
                    };
                };
            };
            style = ''
                * {
                    /* `otf-font-awesome` is required to be installed for icons */
                    font-family: FontAwesome, Ubuntu, Roboto, Helvetica, Arial, sans-serif;
                    font-size: 16px;
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
                    padding: 0 10px;
                    color: #ffffff;
                }

                #window,
                #workspaces {
                    margin: 0 4px;
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
        home.file.".config/xfce4/panel/launcher-2/16812272972.desktop".source =
            .config/xfce4/panel/launcher-2/16812272972.desktop;
        home.file.".config/xfce4/panel/launcher-3/16872964452.desktop".source =
            .config/xfce4/panel/launcher-3/16872964452.desktop;
        home.file.".config/xfce4/panel/launcher-4/16872969311.desktop".source =
            .config/xfce4/panel/launcher-4/16872969311.desktop;
        home.file.".config/xfce4/panel/launcher-5/16812273385.desktop".source =
            .config/xfce4/panel/launcher-5/16812273385.desktop;
        home.file.".config/xfce4/panel/launcher-6/16812273013.desktop".source =
            .config/xfce4/panel/launcher-6/16812273013.desktop;
        home.file.".config/xfce4/panel/battery-13.rc".source =
            .config/xfce4/panel/battery-13.rc;
        home.file.".config/xfce4/panel/datetime-20.rc".source =
            .config/xfce4/panel/datetime-20.rc;
        home.file.".config/xfce4/panel/datetime-22.rc".source =
            .config/xfce4/panel/datetime-22.rc;
        home.file.".config/xfce4/panel/fsguard-14.rc".source =
            .config/xfce4/panel/fsguard-14.rc;
        home.file.".config/xfce4/panel/fsguard-16.rc".source =
            .config/xfce4/panel/fsguard-16.rc;
        home.file.".config/xfce4/panel/fsguard-18.rc".source =
            .config/xfce4/panel/fsguard-18.rc;
        home.file.".config/xfce4/panel/whiskermenu-1.rc".source =
            .config/xfce4/panel/whiskermenu-1.rc;
        home.file.".config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml".source =
            .config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml;
        xresources.properties = {
            "Xft.antialias" = true;
            "Xft.hinting" = true;
            "Xft.rgba" = "rgba";
            "Xft.hintstyle" = "hintslight";
            "Xft.dpi" = 96;
            "Xcursor.size" = 24;
            "Xcursor.theme" = "breeze_cursors";
        };
        programs.zsh = {
            enable = true;
            enableAutosuggestions = true;
            enableCompletion = true;
            autocd = true;
            shellAliases = {
                rm = "trash";
                "\$(date +%Y)" = "echo \"YEAR OF THE LINUX DESKTOP!\"";
            };
            initExtra = "
                # Theme - Based on oh-my-zsh 'gentoo' theme
                autoload -Uz colors && colors
                autoload -Uz vcs_info
                zstyle ':vcs_info:*' check-for-changes true
                zstyle ':vcs_info:*' unstagedstr '%F{red}*'   # display when unstaged changes
                zstyle ':vcs_info:*' stagedstr '%F{yellow}+'  # display when staged changes
                zstyle ':vcs_info:*' actionformats '%F{5}(%F{2}%b%F{3}|%F{1}%a%c%u%m%F{5})%f '
                zstyle ':vcs_info:*' formats '%F{5}(%F{2}%b%c%u%m%F{5})%f '
                zstyle ':vcs_info:svn:*' branchformat '%b'
                zstyle ':vcs_info:svn:*' actionformats "
                    + "'%F{5}(%F{2}%b%F{1}:%{3}%i%F{3}|%F{1}%a%c%u%m%F{5})%f '
                zstyle ':vcs_info:svn:*' formats '%F{5}(%F{2}%b%F{1}:%F{3}%i%c%u%m%F{5})%f '
                zstyle ':vcs_info:*' enable git cvs svn
                zstyle ':vcs_info:git*+set-message:*' hooks untracked-git
                +vi-untracked-git() {
                  if command git status --porcelain 2>/dev/null | command grep -q '??'; then
                    hook_com[misc]='%F{red}?'
                  else
                    hook_com[misc]=''
                  fi
                }
                gentoo_precmd() {
                  vcs_info
                }
                setopt prompt_subst
                autoload -U add-zsh-hook
                add-zsh-hook precmd gentoo_precmd
                PROMPT='%(!.%B%F{red}.%B%F{green}%n@)%m %F{blue}%(!.%1~.%~) "
                    + "\${vcs_info_msg_0_}%F{blue}%(!.#.$)%k%b%f '

                # Extra config options
                setopt extendedglob
                bindkey \"^[[3~\" delete-char
                zstyle ':completion:*' menu select
                export PATH=\"$HOME/.cargo/bin:$PATH\"

                # Hot fix as the history substring search causes issues with \" vs '
                source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/"
                    + "zsh-syntax-highlighting.zsh
                source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/"
                    + "zsh-history-substring-search.zsh
                bindkey \"\$terminfo[kcuu1]\" history-substring-search-up
                bindkey \"\$terminfo[kcud1]\" history-substring-search-down

                paleofetch --recache
            ";
            localVariables = {
                TERM = "xterm-256color";
                EDITOR = "nvim";
            };
        };
    };

    # Technically "system-wide", but similar to home stuff in essence
    programs.neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
        defaultEditor = true;
        withPython3 = true;
        configure = {
            customRC = "
                set nocompatible
                set showmatch
                set ignorecase
                set mouse=a
                set hlsearch
                set incsearch
                set tabstop=4
                set shiftwidth=4
                set expandtab
                set autoindent
                set number
                set wildmode=longest,list
                set cc=100
                filetype plugin indent on
                syntax on
                set clipboard=unnamedplus
                filetype plugin on
                set cursorline
                set ttyfast
                set spell
                set noswapfile

                let g:zig_fmt_autosave = 0
                let g:vimtex_view_method = 'mupdf'

                \" Linting via ale
                let g:ale_linters = {
                    \\ 'python': [ 'pylint' ],
                    \\ 'vim': [ 'vint' ],
                    \\ 'cpp': [ 'clang' ],
                    \\ 'c': [ 'clang' ]
                \\}

                set splitright
                set splitbelow

                \" Latex completion
                call deoplete#custom#var('omni', 'input_patterns', {
                    \\ 'tex': g:vimtex#re#deoplete
                \\})

                \" Open file finder thing
                nnoremap ; :File<CR>

                \" Turn terminal to normal mode with escape
                tnoremap <Esc> <C-\\><C-n>

                \" Open terminal on Ctrl+n
                function! OpenTerminal()
                    split term://zsh
                    resize 10
                endfunction
                nnoremap <C-n> :call OpenTerminal()<CR>

                \" Color schemes
                if (has(\"termguicolors\"))
                    set termguicolors
                endif
                syntax enable

                \" Color scheme
                colorscheme dracula

                \" Configure nerd tree
                let g:NERDTreeShowHidden = 1
                let g:NERDTreeMinimalUI = 0
                let g:NERDTreeIgnore = []
                let g:NERDTreeStatusLine = ''
                nnoremap <silent> <C-b> :NERDTreeToggle<CR>

                \" Move between planes
                nnoremap <C-left> <C-w>h
                nnoremap <C-down> <C-w>j
                nnoremap <C-up> <C-w>k
                nnoremap <C-right> <C-w>l

                \" Create panes
                nnoremap <C-A-d> :sp<CR>
                nnoremap <C-A-r> :vs<CR>

                \" Quit out of vim completely
                nnoremap <C-x> :qa<CR>
                nnoremap <C-s> :w<CR>

                au VimEnter * NERDTree

                \" Vim jump to the last position when reopening a file
                if has(\"autocmd\")
                    au BufReadPost * if line(\"'\\\"\") > 0 && line(\"'\\\"\") <= line(\"$\")
                        \\| exe \"normal! g'\\\"\" | endif
                endif

                \" Load all the plugins now
                packloadall

                \" Load all the help tags now, after loading plugins
                silent! helptags ALL

                \" Start rust-tools
                lua require('rust-tools').setup({})

                \" Code folding
                set foldmethod=indent
            ";
            packages.myVimPackage = with pkgs.vimPlugins; {
                start = [
                    auto-pairs
                    ale
                    coc-git
                    coc-nvim
                    coc-rust-analyzer
                    deoplete-clang
                    deoplete-nvim
                    dracula-vim
                    lightline-vim
                    markdown-preview-nvim
                    nerdcommenter
                    nerdtree
                    nvim-lspconfig
                    rust-tools-nvim
                    ultisnips
                    vim-devicons
                    vim-snippets
                    vim-startify
                    vimtex
                    zig-vim
                ];
            };
        };
    };
}

