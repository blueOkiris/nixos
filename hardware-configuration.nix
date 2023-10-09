# Do not modify this file!    It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.    Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
    imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
    ];

    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "usbhid" "sd_mod" "rtsx_pci_sdmmc" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-intel" ];
    boot.extraModulePackages = [ ];

    fileSystems."/" = {
        device = "/dev/disk/by-uuid/c51d0b12-a6f0-4512-a36a-dda38b7d6cb3";
        fsType = "btrfs";
        options = [ "subvol=@" "compress=zstd:1" ];
    };

    fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/7423-4781";
        fsType = "vfat";
    };

    fileSystems."/games" = {
        device = "/dev/disk/by-uuid/ca9c7716-a554-4ead-82e8-f5f5f5017177";
        fsType = "ext4";
    };

    fileSystems."/home" = {
        device = "/dev/disk/by-uuid/e7d22ff2-f9ad-4f75-8473-4b6881426097";
        fsType = "ext4";
    };

    boot.initrd.luks.devices."home".device = "/dev/disk/by-uuid/489818be-5b8b-4d8c-a4b2-a2e649c7f316";

    swapDevices = [ ];

    # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
    # (the default) this is the recommended approach. When using systemd-networkd it's
    # still possible to use this option, but it's recommended to use it in conjunction
    # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
    networking.useDHCP = lib.mkDefault true;
    # networking.interfaces.enp47s0.useDHCP = lib.mkDefault true;
    # networking.interfaces.wlp49s0.useDHCP = lib.mkDefault true;

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
    hardware.cpu.intel.updateMicrocode =
        lib.mkDefault config.hardware.enableRedistributableFirmware;

    # Enable GameCube adapter
    services.udev.extraRules = 
        "\nSUBSYSTEM==\"usb\", ENV{DEVTYPE}==\"usb_device\", ATTRS{idVendor}==\"057e\", "
            + "ATTRS{idProduct}==\"0337\", MODE=\"0666\"";

    # Enable wireless XBox controller
    hardware.xpadneo.enable = true;

    # Bluetooth enable
    hardware.bluetooth.enable = true;

    # Make mouse work the way any human would want it to
    services.xserver.libinput = {
        touchpad = {
            naturalScrolling = true;
            tapping = true;
            scrollMethod = "twofinger";
            middleEmulation = false;
            tappingButtonMap = "lrm";
            additionalOptions = ''
            Option "MiddleButtonArea" "1"
            '';
        };
        mouse = {
            naturalScrolling = false;
            accelSpeed = "1.0";
        };
    };

    # Nvidia
    hardware.opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
        extraPackages = with pkgs; [
            nvidia-vaapi-driver
            vaapiVdpau
        ];
    };
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia = {
        modesetting.enable = true;
        #open = true;
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

    # Firmware updates
    services.fwupd.enable = true;

    # Disable default power-profile mode to use tlp
    services.power-profiles-daemon.enable = false;
}

