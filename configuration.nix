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
        GTK_THEME = "Arc-Dark";
        GTK_ICON_THEME = "Papirus-Dark";
        RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
    };

    imports = [
        ./hardware-configuration.nix
        ./home-configuration.nix
    ];

    # Bootloader
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.initrd.verbose = false;
    boot.consoleLogLevel = 0;
    boot.initrd.systemd.enable = true;
    boot.kernelParams = [ "quiet" "udev.log_level=3" ];
    boot.plymouth.enable = true;
    boot.plymouth.theme = "breeze";

    # Define your hostname.
    networking.hostName = "msi-raider";

    # Bluetooth enable
    hardware.bluetooth.enable = true;

    # Patch network mangager
    systemd.services.NetworkManager-wait-online.enable = false;

    # Enable GameCube adapter
    services.udev.extraRules = 
        "\nSUBSYSTEM==\"usb\", ENV{DEVTYPE}==\"usb_device\", ATTRS{idVendor}==\"057e\", "
            + "ATTRS{idProduct}==\"0337\", MODE=\"0666\"";

    # Make mouse work the way any human would want it to
    services.xserver.libinput = {
        touchpad = {
            naturalScrolling = true;
            tapping = true;
            scrollMethod = "twofinger";
            middleEmulation = true;
        };
        mouse.naturalScrolling = false;
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
    environment.etc."X11/xorg.conf.d/nvidia.conf".text = ''
        Section "OutputClass"
            Identifier "nvidia"
            MatchDriver "nvidia-drm"
            Driver "nvidia"
            Option "AllowEmptyInitialConfiguration"
            Option "SLI" "Auto"
            Option "BaseMosaic" "on"
            Option "PrimaryGPU" "yes"
        EndSection

        Section "ServerLayout"
            Identifier "layout"
            Option "AllowNVIDIAGPUScreens"
        EndSection
    '';

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
            lightdm = {
                enable = true;
                greeters.slick = {
                    enable = true;
                    theme.name = "Arc-Dark";
                    cursorTheme.name = "breeze_cursors";
                    iconTheme.name = "Papirus-Dark";
                    font.name = "Ubuntu Regular";
                    draw-user-backgrounds = true;
                };
                background = ./gnu-linux-wide-wallpaper.png;
            };
            setupCommands = "
                BIG_MONITOR=\"DP-0\"
                BIG_MONITOR_RES=\"3440x1440\"
                SMALL_MONITOR=\"eDP-1-1\"
                SMALL_MONITOR_RES=\"1920x1080\"
                SMALL_MONITOR_OFFSET=\"2222x1440\"

                ${pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource \"modesetting\" NVIDIA-0
                ${pkgs.xorg.xrandr}/bin/xrandr --auto
                ${pkgs.xorg.xrandr}/bin/xrandr --output \${SMALL_MONITOR} --primary --mode \\
                    \${SMALL_MONITOR_RES} --pos 0x0

                MONITOR_FOUND=`${pkgs.xorg.xrandr}/bin/xrandr --listmonitors | "
                    + "grep -i \${BIG_MONITOR}`
                if [ \"\${MONITOR_FOUND}\" != \"\" ]; then
                    ${pkgs.xorg.xrandr}/bin/xrandr \\
                        --output \${BIG_MONITOR} --primary --mode \${BIG_MONITOR_RES} --pos 0x0 \\
                        --output \${SMALL_MONITOR} --mode \${SMALL_MONITOR_RES} --pos 3440x0
                    sleep 0.25
                    ${pkgs.xorg.xrandr}/bin/xrandr \\
                        --output \${BIG_MONITOR} --primary --mode \${BIG_MONITOR_RES} \\
                            --pos 0x0 --rotate normal \\
                        --output \${SMALL_MONITOR} --mode \${SMALL_MONITOR_RES} \\
                            --pos \${SMALL_MONITOR_OFFSET} --rotate normal
                fi
                exit # Skip generated prime lines
            ";
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

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.dylan = {
        isNormalUser = true;
        description = "Dylan Turner";
        extraGroups = [ "networkmanager" "wheel" "docker" ];
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

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;
    networking.firewall = {
        enable = true;
        allowedTCPPortRanges = [
            { from = 1714; to = 1764; } # KDE Connect
            { from = 2626; to = 2626; } # Dolphin
        ];
        allowedUDPPortRanges = [
            { from = 1714; to = 1764; } # KDE Connect
            { from = 2626; to = 2626; } # Dolphin
        ];
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
        proggyfonts
        ubuntu_font_family
    ];

    # Programs that have modules
    virtualisation.anbox.enable = true;
    programs.dconf.enable = true;
    virtualisation.docker = {
        enable = true;
        storageDriver = "btrfs";
    };
    programs.file-roller.enable = true;
    programs.firefox.enable = true;
    programs.gamemode.enable = true;
    programs.git = {
        enable = true;
        lfs.enable = true;
    };
    programs.gnome-disks.enable = true;
    programs.java.enable = true;
    programs.kdeconnect.enable = true;
    programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
    };
    programs.thunar = {
        enable = true;
        plugins = with pkgs.xfce; [ thunar-archive-plugin thunar-volman thunar-media-tags-plugin ];
    };

    # Tweak some programs
    nixpkgs.overlays = [
        (self: super: {
            waybar = super.waybar.overrideAttrs (oldAttrs: {
                mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
            });
        })
    ];

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
        breeze-gtk
        breeze-plymouth
        brightnessctl
        cargo
        cmake
        cura
        discord
        disfetch
        dolphin-emu
        dunst
        nodejs
        feh
        fontforge
        freecad
        freetube
        gcc
        gimp
        glaxnimate
        gnome.cheese
        gnome.gnome-screenshot
        gnome3.gnome-system-monitor
        gnumake
        hyprpaper
        inkscape
        jstest-gtk
        kdenlive
        kicad
        kid3
        libreoffice
        libsForQt5.qtstyleplugin-kvantum
        lutris
        mediainfo
        mpv
        mupdf
        musescore
        neofetch
        networkmanagerapplet
        nextcloud-client
        numlockx
        openssl
        pandoc
        papirus-icon-theme
        pass
        pavucontrol
        pciutils
        pinentry
        pkg-config

        # Project Plus
        (let
            app_name = "Faster_Project_Plus-x86-64.AppImage";
            gh_proj = "FPM-AppImage";
            gh_user = "Ishiiruka";
            version = "2.4.1";
            hash = "07gcpwf84kn9jl4zmgkzipk5fl9a10pv9rg59pgzhxqrx2nlmpif";
        in pkgs.appimageTools.wrapType2 {
            name = "project+";
            extraPkgs = pkgs: [
                pkgs.gmp
                pkgs.mpg123
                pkgs.libmpg123
            ];
            src = builtins.fetchurl {
                url =
                    "https://github.com/${gh_user}/${gh_proj}/releases/download/"
                        + "v${version}/${app_name}";
                sha256 = "${hash}";
            };
        })

        pulseaudio
        (python3.withPackages(ps: with ps; [ i3ipc ]))
        qjackctl
        rofi
        rust-analyzer
        rustc

        # Slippi
        (let
            app_name = "Slippi_Online-x86_64.AppImage";
            gh_proj = "Ishiiruka";
            gh_user = "slippi";
            version = "3.1.0";
            hash = "039qm941xbl97zvvv0q6480fps4w1a0n71sk1wiacs6n4gm2bs6f";
        in pkgs.appimageTools.wrapType2 {
            name = "slippi";
            extraPkgs = pkgs: [
                pkgs.gmp
                pkgs.mpg123
                pkgs.libmpg123
                pkgs.curl
            ];
            src = builtins.fetchurl {
                url =
                    "https://github.com/${gh_user}/${gh_proj}/releases/download/"
                        + "v${version}/${app_name}";
                sha256 = "${hash}";
            };
        })

        spotify
        teams-for-linux
        texlive.combined.scheme-full
        tigervnc
        trash-cli
        tutanota-desktop
        unzip
        vlc
        wget
        whalebird
        wine
        xclip
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
        "electron-21.4.0"
    ];
}

