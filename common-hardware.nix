# Hardware configuration is mostly for being swapped out for each system
# I have things I'll want no matter what

{ config, lib, pkgs, modulesPath, ... }:

{
    # Allow:
    # - CH55x microcontrollers
    # - GameCube Adapter
    services.udev.extraRules = ''
        SUBSYSTEM=="usb", ATTRS{idVendor}=="4348", MODE="0666"
        SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0337", MODE="0666"
    '';

    # Enable wireless XBox controller
    hardware.xpadneo.enable = true;

    # Bluetooth enable
    hardware.bluetooth.enable = true;
    hardware.bluetooth.settings = {
        General = {
            Enable = "Source,Sink,Media,Socket";
        };
    };

    # Make mouse work the way any human would want it to
    services.libinput = {
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

    # Disable default power-profile mode to use tlp
    services.power-profiles-daemon.enable = false;

    # Firmware updates
    services.fwupd.enable = true;
}

