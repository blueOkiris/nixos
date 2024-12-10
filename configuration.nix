# Edit this configuration file to define what should be installed on
# your system.    Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let
    unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
    deprecated = import <nixos-deprecated> { config = { allowUnfree = true; }; };
    tokyo-night-sddm = pkgs.libsForQt5.callPackage ./custom/tokyo-night-sddm.nix { };
in {
    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "23.05"; # Did you read the comment?

    nixpkgs.config.cudaSupport = true;
    nixpkgs.config.permittedInsecurePackages = [
        "dotnet-core-combined"
        "dotnet-sdk-6.0.428"
        "dotnet-sdk-wrapped-6.0.428"
    ];
    services.logind.lidSwitch = "hibernate";

    # Environment settings
    environment.pathsToLink = [ "/libexec" "/share/zsh" ];
    environment.shells = with pkgs; [ zsh ];
    environment.variables = {
        QT_STYLE_OVERRIDE = lib.mkForce "kvantum";
        GTK_THEME = "Breeze";
        GTK_ICON_THEME = "Papirus-Dark";
        RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
        CUDA_PATH = "${pkgs.cudatoolkit}";
        SSH_ASKPASS = lib.mkForce "";
        GSK_RENDERER = "gl";
    };
    environment.sessionVariables = {
        NIXOS_OZONE_WL = "1";
    };

    imports = [
        ./hardware-configuration.nix
        ./common-hardware.nix
        ./display.nix
        ./home-configuration.nix
        ./custom/cura-appimage.nix
        #./custom/freetube-appimage.nix
        ./custom/paleofetch.nix
        #./custom/gnome-shell-extension-pop-shell.nix
        ./custom/project+.nix
        ./custom/slippi.nix
        #./custom/teams-for-linux.nix
        ./custom/tutanota-appimage.nix
        #./custom/shell-scripts.nix
    ];

    # Bootloader
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.initrd.verbose = false;
    boot.consoleLogLevel = 0;
    boot.initrd.systemd.enable = true;
    boot.kernelPackages = pkgs.linuxPackages;
    boot.kernelParams = [
        "quiet"
        "udev.log_level=3"
        "gcadapter_oc.rate=1"
        #"module_blacklist=i915"
        "intel_iommu=on"
        "iommu=pt"
    ];
    boot.kernelModules = [
        "loop"
        "gcadapter_oc"
        "v4l2loopback"
        "kvm-intel" # NOTE: boot.kernelModules must be unique, so this should be in hardware-config and may change!!!
    ];
    boot.initrd.availableKernelModules = [
        "xhci_pci"
        "thunderbolt"
        "nvme"
        "usb_storage"
        "usbhid"
        "sd_mod"
        "rtsx_pci_sdmmc"
    ];
    boot.extraModulePackages = with config.boot.kernelPackages; [
        v4l2loopback.out
        gcadapter-oc-kmod
    ];
    boot.extraModprobeConfig = ''
        options v4l2loopback exclusive_caps=1 card_label="Virtual Camera"
    '';
    boot.plymouth = {
        enable = true;
        theme = "bgrt"; # Do just this for Nix-themed
        themePackages = with pkgs; [ pkgs.adi1090x-plymouth-themes ];
        #theme = "double"; # Fast spinning white wisps making 2 circles
        #theme = "dragon"; # A colorful dragon eating itself
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
        LC_ALL = "en_US.UTF-8";
        LANG = "en_US.UTF-8";
    };

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.dylan = {
        isNormalUser = true;
        description = "Dylan Turner";
        extraGroups = [
            "networkmanager" "wheel" "docker" "libvirtd" "video" "dialout" "pipewire"
            "audio" "bluetooth"
        ];
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
        #wireplumber.enable = true;
    };
    services.pipewire.wireplumber.extraConfig."11-bluetooth-policy" = {
        "wireplumber.settings" = {
            "bluetooth.autoswitch-to-headset-profile" = false;
        };
    };
    hardware.pulseaudio.enable = false;
    /*environment.etc = {
        "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
            bluez_monitor.properties = {
                ["bluez5.enable"] = true;
                ["bluez5.codecs"] = { "ldac", "aac", "aptx", "aptx_hd", "sbc", "sbc_xq" };
                ["bluez5.enable-sbc"] = true,
                ["bluez5.enable-sbc-xq"] = true,
                ["bluez5.enable-msbc"] = true,
                ["bluez5.enable-hw-volume"] = true,
                ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
                ["bluez5.hfp-backend"] = "none";
            }
        '';
    };*/
    security.pam.loginLimits = [
        { domain = "@audio"; type = "-"; item = "memlock"; value = "unlimited"; }
    ];

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    programs.gnupg = {
        agent = {
            enable = true;
            pinentryPackage = pkgs.pinentry-gnome3;
        };
    };
    #services.picom.enable = false;

    # List services that you want to enable:
    services.avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
    };
    services.blueman.enable = true;
    services.gnome.gnome-keyring.enable = true;
    services.gvfs.enable = true;
    networking.networkmanager = {
        enable = true;
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
    services.printing = {
        enable = true;
        drivers = [ pkgs.hplip ];
    };
    services.snapper = {
        configs = {
            root = {
                SUBVOLUME = "/";
                ALLOW_USERS = [ "dylan" ];
                TIMELINE_CREATE = true;
                TIMELINE_CLEANUP = true;
                SPACE_LIMIT = "0.2";
                NUMBER_LIMIT_IMPORTANT = "1";
            };
        };
        snapshotInterval = "yearly";
        cleanupInterval = "1m";
    };
    services.tlp.enable = true;
    services.udev.packages = with pkgs; [ gnome-settings-daemon ];

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
            { from = 30562; to = 30562; }   # Parsec
            { from = 5357; to = 5357; }     # Samba
            { from = 40118; to = 40118; }   # Drawing tablet

            # Sunshine
            { from = 47984; to = 47984; }
            { from = 47989; to = 47989; }
            { from = 48010; to = 48010; }

            { from = 9420; to = 9420; }     # DB Server Testing
            { from = 3000; to = 3000; }     # Node Server Testing
        ];
        allowedUDPPortRanges = [
            { from = 1714; to = 1764; }     # KDE Connect
            { from = 2626; to = 2626; }     # Dolphin
            { from = 50072; to = 50072; }   # Minecraft LAN
            { from = 25565; to = 25565; }   # Minecraft
            { from = 5267; to = 5267; }     # Ssh
            { from = 2489; to = 2489; }     # Ssh copy
            { from = 6000; to = 6009; }     # Fightcade
            { from = 30562; to = 30562; }   # Parsec
            { from = 3702; to = 3702; }     # Samba
            { from = 40118; to = 40118; }   # Drawing tablet

            # Sunshine
            { from = 47998; to = 48010; }

            { from = 9420; to = 9420; }     # DB Server Testing
            { from = 3000; to = 3000; }     # Node Server Testing
        ];
    };
    networking.firewall.allowPing = true;

    # Fix QT themes
    /*qt = {
        enable = true;
        style = "kvantum";
        platformTheme = "qt5ct";
    };*/

    # Fonts. Font packages in systemPackages won't be accessible
    fonts.packages = with pkgs; [
        cifs-utils
        corefonts
        dina-font
        fira-code
        fira-code-symbols
        font-awesome
        liberation_ttf
        mplus-outline-fonts.githubRelease
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-emoji
        noto-fonts-extra
        powerline-fonts
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
    #programs.file-roller.enable = true;
    #programs.firefox.enable = true;
    services.flatpak.enable = true;
    programs.gamemode.enable = true;
    programs.git = {
        enable = true;
        lfs.enable = true;
    };
    programs.gnome-disks.enable = true;
    programs.java.enable = true;
    programs.kdeconnect.enable = true;
    virtualisation.libvirtd.enable = true;
    programs.nix-ld = {
        enable = true;
        libraries = with pkgs; [
            zlib
            zstd
            stdenv.cc.cc
            stdenv.cc.cc.lib
            udev
            dbus
            mesa
            libglvnd
            curl
            openssl
            attr
            libssh
            bzip2
            libxml2
            acl
            libsodium
            util-linux
            xz
            systemd
        ];
    };
    services.ollama = {
        enable = true;
        acceleration = "cuda";
    };
    virtualisation.spiceUSBRedirection.enable = true;
    programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
    };
    services.sunshine = {
        autoStart = true;
        enable = true;
        capSysAdmin = true;
        openFirewall = true;
    };
    /*programs.thunar = {
        enable = true;
        plugins = with pkgs.xfce; [
            thunar-archive-plugin
            thunar-volman
            thunar-media-tags-plugin
        ];
    };*/
    #programs.waybar.enable = true;
    #virtualisation.waydroid.enable = true;

    # Tweak some programs
    nixpkgs.overlays = [
        # Make waybar work with nvidia/Hyprland
        /*(self: super: {
            waybar = super.waybar.overrideAttrs (oldAttrs: {
                mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
            });
        })*/

        # Allow using Llama w/ sgpt
        (self: super: {
            shell-gpt = super.shell-gpt.overrideAttrs (oldAttrs: {
                propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [
                    pkgs.python3.pkgs.litellm
                ];
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
        #arandr
        #arc-theme
        ardour
        arduino
        arduino-cli
        audacity
        #baobab
        #bc
        blender
        breeze-gtk
        breeze-plymouth
        brightnessctl
        #chafa
        cheese
        csharp-ls
        cudatoolkit
        cudaPackages.cuda_nvcc
        #cura
        dconf-editor
        unstable.discord
        dolphin-emu
        #dunst
        hidapi
        nodejs
        fastfetch
        fd
        fontforge
        unstable.freecad
        gimp
        glaxnimate
        godot_4
        #sway-contrib.grimshot
        hplip
        htop
        #hyprpaper
        inkscape
        jstest-gtk
        kdenlive
        unstable.kicad
        kid3
        lemonade
        #libreoffice
        librewolf
        libthai
        libusb1
        #loupe
        lutris
        mediainfo
        minecraft-server
        #mission-center
        mpv
        mupdf
        musescore
        ncurses
        #neofetch
        networkmanagerapplet
        unstable.nextcloud-client
        #numlockx
        obs-studio
        ols
        omnisharp-roslyn
        onlyoffice-bin
        openssl
        pandoc
        papirus-icon-theme
        pass
        #parsec-bin
        pavucontrol
        pciutils
        #picom
        pinentry
        poppler_utils
        prismlauncher
        protonvpn-gui
        pulseaudio
        pyright
        (python3.withPackages(ps: with ps; [ i3ipc pip setuptools ]))
        qjackctl
        libsForQt5.qt5ct
        #libsForQt5.qtstyleplugin-kvantum
        libsForQt5.qtstyleplugins
        libsForQt5.qt5.qtwayland
        qt6.qtwayland
        #remmina
        (retroarch.override {
            cores = with libretro; [
                mupen64plus
            ];
        })
        #rofi-wayland
        #rofimoji
        rust-analyzer
        shell-gpt
        spice-gtk
        spotify
        system-config-printer
        teensy-udev-rules
        texlive.combined.scheme-full
        thunderbird
        tigervnc
        tokyo-night-sddm
        trash-cli
        usbutils
        unzip
        virt-manager
        virtiofsd
        vlc
        #wdisplays
        wget
        wineWowPackages.stable
        wl-clipboard
        xcape
        xclip
        xfce.exo
        /*xfce.xfce4-panel
        xfce.xfce4-battery-plugin
        xfce.xfce4-clipman-plugin
        xfce.xfce4-datetime-plugin
        xfce.xfce4-fsguard-plugin
        xfce.xfce4-i3-workspaces-plugin
        xfce.xfce4-pulseaudio-plugin
        xfce.xfce4-whiskermenu-plugin*/
        #xorg.xinit
        #xorg.xrandr
        xwayland
        yabridge
        zoom-us
        zsh-autocomplete
        zsh-history-substring-search
    ];
}

