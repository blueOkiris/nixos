# Configure dunst

{ config, lib, pkgs, modulesPath, ... }:

{
    home-manager.users.dylan.services.dunst = {
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
}

