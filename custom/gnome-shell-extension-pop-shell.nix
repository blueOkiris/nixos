# Customize gnome-shell-extensions

{ config, pkgs, lib, ... }:

let
    gnome-shell-extension-pop-shell =
        lib.overrideDerivation pkgs.gnomeExtensions.pop-shell (oldAttrs: {
            patches = [
                ./pop-shell-custom-shortcuts.patch
            ] ++ oldAttrs.patches;
        });
in {
    environment.systemPackages = with pkgs; [
        gnome-shell-extension-pop-shell
    ];
}

