# Edit this configuration file to define what should be installed on
# your system.    Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
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
        QT_STYLE_OVERRIDE = "kvantum";
    };

    imports =
        [ # Include the results of the hardware scan.
            ./hardware-configuration.nix
        ];

    # Bootloader
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Define your hostname.
    networking.hostName = "msi-raider";

    # Bluetooth enable
    hardware.bluetooth.enable = true;

    # Time zone.
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

    # Configure graphics
    services.xserver = {
        layout = "us";
        xkbVariant = "";
        enable = true;

        desktopManager = {
            xterm.enable = false;
            xfce.enable = true; # Install full xfce as panel will break without it
        };

        displayManager = {
            gdm = {
                enable = true;
                wayland = true;
                autoSuspend = false;
            };
            defaultSession = "none+i3";
        };

        windowManager.i3 = {
            enable = true;
            extraPackages = with pkgs; [
                i3lock-fancy
            ];
            package = pkgs.i3-gaps;
        };
    };
    programs.hyprland = {
        enable = true;
        xwayland.enable = true;
        nvidiaPatches = true;
    };

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.dylan = {
        isNormalUser = true;
        description = "Dylan Turner";
        extraGroups = [ "networkmanager" "wheel" ];
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

    # Nvidia
    hardware.opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
    };
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia = {
        modesetting.enable = true;
        open = true;
        nvidiaSettings = true;
        prime = {
            sync.enable = true;
            nvidiaBusId = "PCI:1:0:0";
            intelBusId = "PCI:1:0:0";
        };
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

    # List services that you want to enable:
    networking.networkmanager.enable = true;
    services.blueman.enable = true;
    services.gnome.gnome-keyring.enable = true;

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;
    networking.firewall = {
        enable = true;
        allowedTCPPortRanges = [
            { from = 1714; to = 1764; } # KDE Connect
        ];
        allowedUDPPortRanges = [
            { from = 1714; to = 1764; } # KDE Connect
        ];
    };

    # Program-specific configs
    programs.git = {
        enable = true;
        lfs.enable = true;
    };

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
        alacritty
        android-studio
        arandr
        arc-theme
        ardour
        arduino
        arduino-cli
        baobab
        blender
        blueman
        breeze-gtk
        brightnessctl
        cargo
        cura
        discord
        dunst
        elmPackages.nodejs
        feh
        firefox
        fontforge
        freecad
        freetube
        gcc
        gimp
        glaxnimate
        gnome.cheese
        gnome.gnome-disk-utility
        gnome.gnome-screenshot
        gnome3.gnome-system-monitor
        gnumake
        inkscape
        jdk
        jstest-gtk
        kdeconnect
        kdenlive
        kicad
        kid3
        libreoffice
        libsForQt5.qtstyleplugin-kvantum
        lutris
        lxappearance
        mediainfo
        mpv
        mupdf
        musescore
        neofetch
        neovim
        networkmanager_strongswan
        networkmanagerapplet
        nextcloud-client
        numlockx
        openssl
        papirus-icon-theme
        pavucontrol
        pciutils
        picom
        pinentry
        pkg-config
        (python3.withPackages(ps: with ps; [ neovim i3ipc ]))
        pulseaudio
        qjackctl
        rofi
        rustc
        snapper
        spotify
        spotifyd
        steam
        teams-for-linux
        texlive.combined.scheme-full
        tigervnc
        trash-cli
        tutanota-desktop
        ubuntu_font_family
        unzip
        vlc
        waybar
        wget
        whalebird
        wine
        xclip
        xfce.thunar
        xfce.thunar-archive-plugin
        xfce.thunar-media-tags-plugin
        xfce.thunar-volman
        xfce.xfce4-panel
        xfce.xfce4-battery-plugin
        xfce.xfce4-clipman-plugin
        xfce.xfce4-datetime-plugin
        xfce.xfce4-fsguard-plugin
        xfce.xfce4-i3-workspaces-plugin
        xfce.xfce4-pulseaudio-plugin
        xfce.xfce4-whiskermenu-plugin
        yabridge
        yarn
        zoom
        zsh-autocomplete
        zsh-history-substring-search
    ];

    # Hack
    nixpkgs.config.permittedInsecurePackages = [
        "electron-19.0.7"
    ];
}
