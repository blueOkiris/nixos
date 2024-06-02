# Configure alacritty with home-manager

{ config, lib, pkgs, modulesPath, ... }:

{
    home-manager.users.dylan.programs.alacritty = {
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
            window = {
                decorations = "none";
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
}

