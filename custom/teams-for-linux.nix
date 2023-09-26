# Package a working version of the Teams for Linux AppImage (electron was broken)

{ config, pkgs, lib, ... }:

let
    teams-for-linux-appimage = (
        let
            app_name = "teams-for-linux";
            gh_user = "IsmaelMartinez";
            gh_proj = "teams-for-linux";
            version = "1.3.8";
            hash = "053qv3chj2yx928b4ww39hnskv6a01q16mnh3pig7iihkznmqkp8";
        in pkgs.appimageTools.wrapType2 {
            name = "teams-for-linux";
            extraPkgs = pkgs: [];
            src = builtins.fetchurl {
                url = "https://github.com/${gh_user}/${gh_proj}/releases/download/v${version}/"
                    + "${app_name}-${version}.AppImage";
                sha256 = "${hash}";
            };
        }
    );
in {
    environment.systemPackages = with pkgs; [
        teams-for-linux-appimage
    ];

}

