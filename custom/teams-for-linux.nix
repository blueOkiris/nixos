# Package a working version of the Teams for Linux AppImage (electron was broken)

{ config, pkgs, lib, ... }:

let
    teams-for-linux-appimage = (
        let
            app_name = "teams-for-linux";
            gh_user = "IsmaelMartinez";
            gh_proj = "teams-for-linux";
            version = "1.3.14";
            hash = "0sfdf9ybkadvf8p22kv16i6ww5sv0xq0fk1i8ycvink5p0rx6x0j";
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

