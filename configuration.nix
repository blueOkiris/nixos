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
    };

    imports = [
        ./hardware-configuration.nix
        <home-manager/nixos>
        ./home-configuration.nix
    ];

    # Bootloader
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Define your hostname.
    networking.hostName = "msi-raider";

    # Bluetooth enable
    hardware.bluetooth.enable = true;

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
    home-manager.users.dylan = { pkgs, ... }: {
        programs.zsh = {
            enable = true;
            enableAutosuggestions = true;
            enableCompletion = true;
            enableSyntaxHighlighting = true;
            autocd = true;
            historySubstringSearch = {
                enable = true;
                # Can't use because it uses ' instead of ", so it doesn't eval
                #searchUpKey = "\$terminfo[kcuu1]";
                #searchDownKey = "\$terminfo[kcud1]";
            };
            shellAliases = {
                rm = "trash";
                "\$(date +%Y)" = "echo \"YEAR OF THE LINUX DESKTOP!\"";
            };
            initExtra = "
# Theme - Based on oh-my-zsh 'gentoo' theme
autoload -Uz colors && colors
autoload -Uz vcs_info
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '%F{red}*'   # display this when there are unstaged changes
zstyle ':vcs_info:*' stagedstr '%F{yellow}+'  # display this when there are staged changes
zstyle ':vcs_info:*' actionformats '%F{5}(%F{2}%b%F{3}|%F{1}%a%c%u%m%F{5})%f '
zstyle ':vcs_info:*' formats '%F{5}(%F{2}%b%c%u%m%F{5})%f '
zstyle ':vcs_info:svn:*' branchformat '%b'
zstyle ':vcs_info:svn:*' actionformats '%F{5}(%F{2}%b%F{1}:%{3}%i%F{3}|%F{1}%a%c%u%m%F{5})%f '
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
PROMPT='%(!.%B%F{red}.%B%F{green}%n@)%m %F{blue}%(!.%1~.%~) \${vcs_info_msg_0_}%F{blue}%(!.#.$)%k%b%f '

# Extra config options
setopt extendedglob
bindkey \"^[[3~\" delete-char
zstyle ':completion:*' menu select
            ";
            localVariables = {
                TERM = "xterm-256color";
                PATH = "$HOME/.local/bin;$HOME/.cargo/bin:$PATH";
                EDITOR = "nvim";
            };
        };
        home.stateVersion = "23.05";
        home.packages = [ ];
    };
    home-manager.useGlobalPkgs = true;

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
        ];
        allowedUDPPortRanges = [
            { from = 1714; to = 1764; } # KDE Connect
        ];
    };

    # Programs that have modules
    virtualisation.anbox.enable = true;
    programs.dconf.enable = true;
    programs.firefox.enable = true;
    programs.gamemode.enable = true;
    programs.git = {
        enable = true;
        lfs.enable = true;
    };
    programs.gnome-disks.enable = true;
    programs.java.enable = true;
    programs.kdeconnect.enable = true;
    programs.neovim = {
        enable = true;
        viAlias = true;
        # TODO: configure here instead of using init.nvim for root and user
        defaultEditor = true;
    };
    programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
    };
    programs.waybar.enable = true;
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

    # Fonts. Font packages in systemPackages won't be accessible
    fonts.fonts = with pkgs; [
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
        brightnessctl
        cargo
        cura
        discord
        dunst
        elmPackages.nodejs
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
        lxappearance
        mediainfo
        mpv
        mupdf
        musescore
        neofetch
        networkmanagerapplet
        nextcloud-client
        numlockx
        openssl
        papirus-icon-theme
        pass
        pavucontrol
        pciutils
        picom # Potentially enable at system level; Only used for i3 rn though, so maybe not
        pinentry
        pkg-config
        (python3.withPackages(ps: with ps; [ neovim i3ipc ]))
        pulseaudio
        qjackctl
        rofi
        rustc
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
        "electron-19.0.7"
    ];
}
