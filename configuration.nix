# Edit this configuration file to define what should be installed on
# your system.    Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let
    unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {
    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "23.05"; # Did you read the comment?

    # Environment settings
    environment.pathsToLink = [ "/libexec" "/share/zsh" ];
    environment.shells = with pkgs; [ zsh ];
    environment.variables = {
        QT_STYLE_OVERRIDE = lib.mkForce "kvantum";
        GTK_THEME = "Arc-Dark";
        GTK_ICON_THEME = "Papirus-Dark";
        RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
        #__GLX_VENDOR_LIBRARY_NAME = "nvidia";
        #__NV_PRIME_RENDER_OFFLOAD = "1";
        #__NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
        #__VK_LAYER_NV_optimus = "NVIDIA_only";
    };

    imports = [
        ./hardware-configuration.nix
        ./home-configuration.nix

        ./ni-vpn/ni-vpn.nix

        ./custom/freetube-appimage.nix
        ./custom/paleofetch.nix
        ./custom/gnome-shell-extension-pop-shell.nix
        ./custom/project+.nix
        ./custom/slippi.nix
        ./custom/teams-for-linux.nix
        ./custom/tutanota-appimage.nix
        ./custom/shell-scripts.nix
    ];

    # Bootloader
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.initrd.verbose = false;
    boot.consoleLogLevel = 0;
    boot.initrd.systemd.enable = true;
    boot.kernelParams = [
        "quiet"
        "udev.log_level=3"
        "gcadapter_oc.rate=1"
        #"module_blacklist=i915"
    ];
    boot.kernelModules = [
        "loop"
        "gcadapter_oc"
    ];
    boot.plymouth = {
        enable = true;
        #theme = "breeze"; # Do just this for Nix-themed
        themePackages = with pkgs; [ pkgs.adi1090x-plymouth-themes ];
        #theme = "double"; # Fast spinning white wisps making 2 circles
        theme = "dragon"; # A colorful dragon eating itself
        #theme = "green_loader"; # Green partial rings spinning and growing bigger & smlr
        #theme = "loader_2"; # White balls that fall in on themselves
        #theme = "loader_alt"; # Blue balls (more than loader_2) that fall into center
        #theme = "pixels"; # Red, green, and blue airbrush ball things orbitting eachother
        #theme = "rings_2"; # Colorful 3D saturns-rings things
        #theme = "spin"; # Colorful spinning rings
        #theme = "spinner_alt"; # Ubuntu-like loading symbol. Dot's become 3 parts of circ
    };
    boot.loader.systemd-boot.configurationLimit = 6;

    # Define your hostname.
    networking.hostName = "msi-raider";

    # Patch network manager for NixOS unstable
    systemd.services.NetworkManager-wait-online.enable = false;

    # Time zons.
    time.timeZone = "America/Chicago";

    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
    };

    # Configure display server
    services.xserver = {
        layout = "us";
        xkbVariant = "";
        enable = true;

        desktopManager = {
            xterm.enable = false;
            #xfce.enable = true; # Install full xfce as panel will break without it
            gnome.enable = true;
        };

        displayManager = {
            lightdm = {
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
            };
            setupCommands =
                let
                    big_mon = "DP-1-0";
                    big_mon_res = "3440x1440";
                    big_mon_rate = "60";
                    big_mon_pos = "0x0";
                    small_mon = "eDP-1";
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
    environment.gnome.excludePackages =
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
        ]);
    #environment.xfce.excludePackages = with pkgs.xfce; [ mousepad xfce4-terminal ];
    programs.hyprland = {
        enable = true;
        xwayland.enable = true;
        nvidiaPatches = true;
    };
    services.dbus.enable = true;
    xdg.portal = {
        enable = true;
        extraPortals = [
            #pkgs.xdg-desktop-portal-gtk
            pkgs.xdg-desktop-portal-gnome
            #pkgs.xdg-desktop-portal-hyprland
        ];
    };

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.dylan = {
        isNormalUser = true;
        description = "Dylan Turner";
        extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" "video" ];
        shell = pkgs.zsh;
    };
    programs.zsh = {
        enable = true;
        autosuggestions.enable = true;
        syntaxHighlighting.enable = true;
    };

    # Sound
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
    };
    hardware.pulseaudio.enable = false;
    environment.etc = {
        "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
            bluez_monitor.properties = {
                ["bluez5.enable-sbc-xq"] = true,
                ["bluez5.enable-msbc"] = true,
                ["bluez5.enable-hw-volume"] = true,
                ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
            }
        '';
    };

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    programs.gnupg = {
        agent = {
            enable = true;
            pinentryFlavor = "gnome3";
        };
    };

    services.picom.enable = false;

    # List services that you want to enable:
    networking.networkmanager = {
        enable = true;
        enableStrongSwan = true;
    };
    services.blueman.enable = true;
    services.gnome.gnome-keyring.enable = true;
    services.snapper = {
        configs = {
            root = {
                SUBVOLUME = "/";
                ALLOW_USERS = [ "dylan" ];
                TIMELINE_CREATE = true;
                TIMELINE_CLEANUP = true;
            };
        };
        snapshotInterval = "hourly";
        cleanupInterval = "1d";
    };
    services.printing = {
        enable = true;
        drivers = [ pkgs.hplip ];
    };
    services.avahi = {
        enable = true;
        nssmdns = true;
        openFirewall = true;
    };
    services.openssh = {
        enable = true;
        ports = [ 5267 ];
        settings = {
            PasswordAuthentication = false;
            PubkeyAuthentication = true;
            X11Forwarding = true;
        };
    };
    services.tlp.enable = true;
    services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;
    networking.firewall = {
        enable = true;
        allowedTCPPortRanges = [
            { from = 1714; to = 1764; }     # KDE Connect
            { from = 2626; to = 2626; }     # Dolphin
            { from = 50072; to = 50072; }   # Minecraft LAN
            { from = 25565; to = 25565; }   # Minecraft
            { from = 5267; to = 5267; }     # Ssh
            { from = 2489; to = 2489; }     # Ssh copy
            { from = 6000; to = 6009; }     # Fightcade
        ];
        allowedUDPPortRanges = [
            { from = 1714; to = 1764; }     # KDE Connect
            { from = 2626; to = 2626; }     # Dolphin
            { from = 50072; to = 50072; }   # Minecraft LAN
            { from = 25565; to = 25565; }   # Minecraft
            { from = 5267; to = 5267; }     # Ssh
            { from = 2489; to = 2489; }     # Ssh copy
            { from = 6000; to = 6009; }     # Fightcade
        ];
    };

    # Fix QT themes
    qt = {
        enable = true;
        style.name = "kvantum";
        platformTheme = "qt5ct";
    };

    # Fonts. Font packages in systemPackages won't be accessible
    fonts.fonts = with pkgs; [
        corefonts
        dina-font
        fira-code
        fira-code-symbols
        font-awesome
        liberation_ttf
        mplus-outline-fonts.githubRelease
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
        noto-fonts-extra
        proggyfonts
        ubuntu_font_family
        unifont
        unifont_upper
    ];

    # Programs that have modules
    programs.dconf.enable = true;
    virtualisation.docker = {
        enable = true;
        storageDriver = "btrfs";
    };
    programs.file-roller.enable = true;
    programs.firefox.enable = true;
    services.flatpak.enable = true;
    programs.gamemode.enable = true;
    programs.git = {
        enable = true;
        lfs.enable = true;
    };
    programs.gnome-disks.enable = true;
    programs.java.enable = true;
    #programs.kdeconnect.enable = true;
    virtualisation.libvirtd.enable = true;
    programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
    };
    programs.thunar = {
        enable = true;
        plugins = with pkgs.xfce; [ thunar-archive-plugin thunar-volman thunar-media-tags-plugin ];
    };
    programs.waybar.enable = true;
    #virtualisation.waydroid.enable = true;

    # Tweak some programs
    nixpkgs.overlays = [
        # Make waybar work with nvidia/Hyprland
        (self: super: {
            waybar = super.waybar.overrideAttrs (oldAttrs: {
                mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
            });
        })

        # Start Firefox with Nvidia GPU
        (self: super: {
            firefox = super.firefox.overrideAttrs (oldAttrs: {
                postInstall = (oldAttrs.postInstall or "") + ''
                    substituteInPlace $out/share/applications/firefox.desktop \
                        --replace "firefox --name firefox %U" \
                            "nvidia-offload firefox --name firefox %U" \
                        --replace "firefox --private-window %U" \
                            "nvidia-offload firefox --private-window %U" \
                        --replace "firefox --new-window %U" \
                            "nvidia-offload firefox --new-window %U" \
                        --replace "firefox --ProfileManager %U" \
                            "nvidia-offload firefox --ProfileManager %U"
                '';
            });
        })
    ];

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # List packages installed in system profile. To search, run:
    environment.systemPackages = with pkgs; [
        alacritty
        android-studio
        appimage-run
        arandr
        arc-theme
        ardour
        arduino
        arduino-cli
        baobab
        bc
        blender
        breeze-gtk
        breeze-plymouth
        brightnessctl
        chafa
        cura
        discord
        dolphin-emu
        dunst
        nodejs
        feh
        fd
        fontforge
        freecad
        gimp
        glaxnimate
        gnome.cheese
        gnome.dconf-editor
        gnome.gnome-screenshot
        gnome.gnome-tweaks
        gnomeExtensions.dash-to-dock
        gnomeExtensions.gsconnect
        gnomeExtensions.rounded-window-corners
        gnomeExtensions.sound-output-device-chooser
        gnomeExtensions.tray-icons-reloaded
        gnomeExtensions.user-themes
        unstable.godot_4
        sway-contrib.grimshot
        hplip
        htop
        hyprpaper
        inkscape
        jstest-gtk
        kdenlive
        kicad
        kid3
        lemonade
        libreoffice
        libsForQt5.qt5.qtwayland
        libsForQt5.qt5ct
        libsForQt5.qtstyleplugin-kvantum
        libsForQt5.qtstyleplugins
        lutris
        mediainfo
        minecraft-server
        unstable.mission-center
        mpv
        mupdf
        musescore
        ncurses
        neofetch
        networkmanagerapplet
        nextcloud-client
        numlockx
        obs-studio
        openssl
        pandoc
        papirus-icon-theme
        pass
        pavucontrol
        pciutils
        picom
        pinentry
        poppler_utils
        prismlauncher
        pulseaudio
        (python3.withPackages(ps: with ps; [ i3ipc pip ]))
        qjackctl
        qt6.qtwayland
        remmina
        rofi
        rust-analyzer
        ryujinx
        spotify
        system-config-printer
        strongswan
        texlive.combined.scheme-full
        texstudio
        tigervnc
        trash-cli
        typst
        unzip
        virt-manager
        vlc
        wdisplays
        wget
        wineWowPackages.stable
        wl-clipboard
        xcape
        xclip
        xfce.xfce4-panel
        xfce.xfce4-battery-plugin
        xfce.xfce4-clipman-plugin
        xfce.xfce4-datetime-plugin
        xfce.xfce4-fsguard-plugin
        xfce.xfce4-i3-workspaces-plugin
        xfce.xfce4-pulseaudio-plugin
        xfce.xfce4-whiskermenu-plugin
        xorg.xinit
        xorg.xrandr
        xwayland
        yabridge
        zoom
        zsh-autocomplete
        zsh-history-substring-search
    ];
}

