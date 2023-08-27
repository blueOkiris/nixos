# Edit this configuration file to define what should be installed on
# your system.    Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let
    # Custom packages before config
    paleofetch = pkgs.stdenv.mkDerivation rec {
        name = "paleofetch";
        src = pkgs.fetchFromGitHub {
            owner = "blueOkiris";
            repo = "paleofetch-nixos";
            rev = "a1e1a2f1f9d778d836c8d9bfaa8d44ddf8d2da4e";
            sha256 = "1a00n2kq5d9i2sw2fblac1n7ml48xj4zilrsqabayjnjf67vh5zn";
        };
        buildInputs = [ pkgs.gcc pkgs.gnumake pkgs.pciutils pkgs.xorg.libX11 ];
        buildPhase = ''
            mkdir -p $out
            cp -ra $src/* $out
            cd $out
            make
            rm -rf obj/
        '';
        installPhase = ''
            mkdir -p $out/bin
            cp $out/paleofetch $out/bin
        '';
    };
    projectplus = (
        let
            app_name = "Faster_Project_Plus-x86-64.AppImage";
            gh_proj = "FPM-AppImage";
            gh_user = "Ishiiruka";
            version = "2.4.2";
            hash = "0vgg9xvlk94mp0ip5473py381l2bpd2anqibpyp0jkp4xq6wdkm3";
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
        }
    );
    slippi = (
        let
            app_name = "Slippi_Online-x86_64.AppImage";
            gh_proj = "Ishiiruka";
            gh_user = "project-slippi";
            version = "3.2.2";
            hash = "12k344ky4kp4i9sr847sh9hzq1h8w42msd25gkf5zpmx0s7v8y4r";
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
        }
    );
    gnome-shell-extension-pop-shell =
        lib.overrideDerivation pkgs.gnomeExtensions.pop-shell (oldAttrs: {
            patches = [
                ./pop-shell-custom-shortcuts.patch
            ] ++ oldAttrs.patches;
        });
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
                    user-session=gnome-wayland
                '';
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
    programs.hyprland = {
        enable = true;
        xwayland.enable = true;
        enableNvidiaPatches = true;
    };
    services.dbus.enable = true;
    xdg.portal = {
        enable = true;
        extraPortals = [
            #pkgs.xdg-desktop-portal-gtk
            #pkgs.xdg-desktop-portal-hyprland
        ];
    };
    services.xrdp.enable = true;
    services.xrdp.defaultWindowManager = "i3";

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.dylan = {
        isNormalUser = true;
        description = "Dylan Turner";
        extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" ];
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
    services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

    # VPN
    environment.etc."ssl/certs/DigiCertGlobalRootG2.crt".source = ./DigiCertGlobalRootG2.crt;
    environment.etc."ssl/certs/DigiCertGlobalG2TLSRSASHA2562020CA1.crt ".source =
        ./DigiCertGlobalG2TLSRSASHA2562020CA1.crt;
    # Backup Manual method
    #services.strongswan = {
    #    enable = true;
    #    connections = {
    #        "%default" = {
    #            ikelifetime = "8h";
    #            reauth = "no";
    #            keylife = "20m";
    #            rekeymargin = "3m";
    #            #keyringtries = "1";
    #            keyexchange = "ikev2";
    #            mobike = "yes";
    #        };
    #        "ni-vpn" = {
    #            left = "%any";
    #            leftsourceip = "%config";
    #            leftfirewall = "yes";
    #            leftauth = "eap-mschapv2";
    #            right = "vpn-us1.natinst.com";
    #            rightid = "%vpn.natinst.com";
    #            rightsubnet = "0.0.0.0/0";
    #            rightdns = "172.18.18.80,172.18.20.80";
    #            auto = "add";
    #        };
    #    };
    #    ca = {
    #        ni-vpn-rsa = {
    #            auto = "add";
    #            cacert = "/etc/nixos/DigiCertGlobalG2TLSRSASHA2562020CA1.crt";
    #        };
    #        ni-vpn-cert = {
    #            auto = "add";
    #            cacert = "/etc/nixos/DigiCertGlobalRootG2.crt";
    #        };
    #    };
    #};

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
            { from = 3389; to = 3389; }     # xrdp
            { from = 5267; to = 5267; }     # Ssh
            { from = 2489; to = 2489; }     # Ssh copy
        ];
        allowedUDPPortRanges = [
            { from = 1714; to = 1764; }     # KDE Connect
            { from = 2626; to = 2626; }     # Dolphin
            { from = 50072; to = 50072; }   # Minecraft LAN
            { from = 25565; to = 25565; }   # Minecraft
            { from = 3389; to = 3389; }     # xrdp
            { from = 5267; to = 5267; }     # Ssh
            { from = 2489; to = 2489; }     # Ssh copy
        ];
    };

    # Fonts. Font packages in systemPackages won't be accessible
    fonts.packages = with pkgs; [
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
    virtualisation.waydroid.enable = true;

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

    # We don't want everything that comes with gnome and xfce
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
            gnome-weather
            hitori
            iagno
            nautilus
            simple-scan
            tali
            totem
            yelp
        ]);
    environment.xfce.excludePackages = with pkgs.xfce; [ mousepad xfce4-terminal ];

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
        chafa
        cmake
        cura
        discord
        dolphin-emu
        dunst
        nodejs
        feh
        fd
        fontforge
        freecad
        freetube
        gcc
        gdb
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
        gnome-shell-extension-pop-shell
        gnumake
        sway-contrib.grimshot
        htop
        hyprpaper
        inkscape
        jstest-gtk
        kdenlive
        kicad
        kid3
        lemonade
        libpng
        libreoffice
        libsForQt5.qtstyleplugin-kvantum
        libusb1
        lutris
        mediainfo
        minecraft-server
        mission-center
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
        paleofetch
        papirus-icon-theme
        pass
        pavucontrol
        pciutils
        pinentry
        pkg-config
        poppler_utils
        prismlauncher
        projectplus
        pulseaudio
        (python3.withPackages(ps: with ps; [ i3ipc pip ]))
        qjackctl
        libsForQt5.qt5.qtwayland
        qt6.qtwayland
        rofi
        rust-analyzer
        rustc
        ryujinx
        SDL2
        slippi
        spotify
        system-config-printer
        strongswan
        teams-for-linux
        texlive.combined.scheme-full
        tigervnc
        trash-cli
        tutanota-desktop
        udev
        unzip
        virt-manager
        vlc
        wdisplays
        wget
        whalebird
        wineWowPackages.stable
        wl-clipboard
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
        yarn
        zoom
        zsh-autocomplete
        zsh-history-substring-search
    ];

    # Hack
    nixpkgs.config.permittedInsecurePackages = [
        "electron-21.4.4"
    ];
}

