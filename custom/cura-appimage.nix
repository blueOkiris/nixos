# Override to make sure cura is most recent version

{ config, pkgs, lib, ... }:

let
    cura-appimage = (
        let
            app_name = "cura";
            gh_user = "Ultimaker";
            gh_proj = "Cura";
            version = "5.9.0";
            hash = "17h2wy2l9djzcinmnjmi2c7d2y661f6p1dqk97ay7cqrrrw5afs9";
        in pkgs.appimageTools.wrapType2 {
            name = "cura";
            extraPkgs = pkgs: [];
            src = builtins.fetchurl {
                url = "https://github.com/${gh_user}/${gh_proj}/releases/download/${version}/"
                    + "${gh_user}-${gh_proj}-${version}-linux-X64.AppImage";
                sha256 = "${hash}";
            };
        }
    );
in {
    environment.systemPackages = with pkgs; [
        cura-appimage
    ];
}

