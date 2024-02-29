# Package a working Tutanota AppImage (electron was broken)

{ config, pkgs, lib, ... }:

let
    tutanota-appimage = (
        let
            app_name = "tutanota-desktop-linux";
            gh_user = "tutao";
            gh_proj = "tutanota";
            version = "218.240227.0";
            hash = "1s66lkywwvc6afmqjfjyq5zyz8r06jww8zicnfp6lrzi5p87z2kp";
        in pkgs.appimageTools.wrapType2 {
            name = "tutanota";
            extraPkgs = pkgs: [
                pkgs.libsecret
            ];
            src = builtins.fetchurl {
                url = "https://github.com/${gh_user}/${gh_proj}/releases/download/"
                    + "tutanota-desktop-release-${version}/${app_name}.AppImage";
                sha256 = "${hash}";
            };
        }
    );
in {
    environment.systemPackages = with pkgs; [
        tutanota-appimage
    ];
}

