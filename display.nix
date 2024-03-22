# Set up display managers, DEs, etc

{ config, pkgs, lib, ... }:

{
    services.xserver = {
        layout = "us";
        xkbVariant = "";
        enable = true;

        desktopManager = {
            xterm.enable = false;
            #xfce.enable = true; # Install full xfce as panel will break without it
            #gnome.enable = true;
        };

        displayManager = {
            defaultSession = "hyprland";
            /*lightdm = {
                enable = true;
                greeters.slick = {
                    enable = true;
                    theme.name = "Arc-Dark";
                    cursorTheme.name = "breeze_cursors";
                    iconTheme.name = "Papirus-Dark";
                    font.name = "Ubuntu Regular";
                    draw-user-backgrounds = false;
                };
                background = ./gnu-linux-wide-wallpaper.png;
                extraSeatDefaults = ''
                    user-session=none+i3
                '';
                #extraSeatDefaults = ''
                #    user-session=gnome-wayland
                #'';
            };*/
            sddm = {
                enable = true;
                wayland.enable = true;
                autoNumlock = true;
                #theme = "chili";
                theme = "tokyo-night-sddm";
            };
            setupCommands =
                let
                    big_mon = "DP-0";
                    big_mon_res = "3440x1440";
                    big_mon_rate = "60";
                    big_mon_pos = "0x0";
                    small_mon = "eDP-1-1";
                    small_mon_res = "1920x1080";
                    small_mon_rate = "360";
                    small_mon_pos = "1969x1440";
                    dpi = "96";
                in ''
                    ${pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource "modesetting" NVIDIA-0
                    ${pkgs.xorg.xrandr}/bin/xrandr --auto

                    # Default
                    ${pkgs.xorg.xrandr}/bin/xrandr \
                        --output ${small_mon} --primary \
                        --mode ${small_mon_res} --pos 0x0 -r ${small_mon_rate} \
                        --dpi 96

                    # Check for external DP display
                    MON_FOUND=`${pkgs.xorg.xrandr}/bin/xrandr --listmonitors | grep -i ${big_mon}`
                    if [ "$MON_FOUND" != "" ]; then
                        ${pkgs.xorg.xrandr}/bin/xrandr \
                            --output ${big_mon} --primary --mode ${big_mon_res} \
                            --pos 0x0 -r ${big_mon_rate} --dpi ${dpi} \
                            --output ${small_mon} --mode ${small_mon_res} \
                            --pos 3440x0 -r ${small_mon_rate} --dpi ${dpi}
                        # Takes 2 tries for some reason
                        sleep 0.25
                        ${pkgs.xorg.xrandr}/bin/xrandr \
                            --output ${big_mon} --primary --mode ${big_mon_res} \
                            --pos ${big_mon_pos} -r ${big_mon_rate} --dpi ${dpi} \
                            --output ${small_mon} --mode ${small_mon_res} \
                            --pos ${small_mon_pos} -r ${small_mon_rate} --dpi ${dpi}
                    fi
                    exit # Skip generated prime lines
                '';
        };
        windowManager.i3 = {
            enable = true;
            extraPackages = with pkgs; [
                i3lock-fancy
                dex
            ];
            package = pkgs.i3-gaps;
        };
    };
    # We don't want everything that comes with the bigger DEs
    /*environment.gnome.excludePackages =
        (with pkgs; [
            gnome-connections
            gnome-console
            gnome-doc-utils
            gnome-photos
            gnome-text-editor
            gnome-tour
        ]) ++ (with pkgs.gnome; [
            atomix
            eog
            epiphany
            evince
            gdm
            geary
            gedit
            ghex
            gnome-calculator
            gnome-calendar
            gnome-characters
            gnome-contacts
            gnome-maps
            gnome-music
            gnome-terminal
            gnome-software
            gnome-system-monitor
            gnome-weather
            hitori
            iagno
            nautilus
            simple-scan
            tali
            totem
            yelp
        ]);*/
    #environment.xfce.excludePackages = with pkgs.xfce; [ mousepad xfce4-terminal ];
    programs.hyprland = {
        enable = true;
        xwayland.enable = true;
        enableNvidiaPatches = true;
    };
    services.dbus.enable = true;
    xdg.portal = {
        enable = true;
        wlr.enable = true;
        extraPortals = [
            #pkgs.xdg-desktop-portal-gtk
            #pkgs.xdg-desktop-portal-gnome
            #pkgs.xdg-desktop-portal-hyprland
        ];
    };
}

