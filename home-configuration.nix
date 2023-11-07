# Home folder configuration for user "dylan"

{ config, lib, pkgs, modulesPath, ... }:

{
    imports = [
        <home-manager/nixos>
        ./home-config/alacritty.nix
        ./home-config/dunst.nix
        ./home-config/i3.nix
        ./home-config/neovim.nix
        ./home-config/picom.nix
        ./home-config/waybar.nix
        ./home-config/xfce4-panel.nix
        ./home-config/zsh.nix
    ];
    home-manager.useGlobalPkgs = true;
    home-manager.users.dylan = { pkgs, ... }: {
        home.stateVersion = "23.05";
        home.packages = [ ];
        home.file.".local/share/applications/freetube.desktop".source =
            home-config/desktops/freetube.desktop;
        gtk = {
            enable = true;
            theme.name = "Arc-Dark";
            iconTheme.name = "Papirus-Dark";
            cursorTheme.name = "breeze_cursors";
        };
        home.file.".config/hypr/hyprland.conf".source = home-config/.config/hypr/hyprland.conf;
        home.file.".config/hypr/hyprpaper.conf".source = home-config/.config/hypr/hyprpaper.conf;
        home.file.".local/share/applications/lock-screen.desktop".source =
            home-config/desktops/lock-screen.desktop;
        home.file.".profile".source = ./home-config/.profile;
        home.file.".local/share/icons/project-plus.png".source =
            home-config/desktops/project+_logo.png;
        home.file.".local/share/applications/project+.desktop".source =
            home-config/desktops/project+.desktop;
        home.file.".local/share/icons/slippi.png".source =
            home-config/desktops/slippi_logo.png;
        home.file.".local/share/applications/slippi.desktop".source =
            home-config/desktops/slippi.desktop;
        home.file.".local/share/applications/teams.desktop".source =
            home-config/desktops/teams-for-linux.desktop;
        xresources.properties = {
            "Xft.antialias" = true;
            "Xft.hinting" = true;
            "Xft.rgba" = "rgba";
            "Xft.hintstyle" = "hintslight";
            "Xft.dpi" = 96;
            "Xcursor.size" = 24;
            "Xcursor.theme" = "breeze_cursors";
        };
        home.file.".local/share/applications/tutanota.desktop".source =
            home-config/desktops/tutanota.desktop;
    };
}

