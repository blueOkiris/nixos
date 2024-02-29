# Package a working Tutanota AppImage (electron was broken)

{ config, pkgs, lib, ... }:

let
    tutanota-appimage = (
        let
            app_name = "tutanota-desktop-linux";
            gh_user = "tutao";
            gh_proj = "tutanota";
            version = "218.240219.0";
            hash = "1rngmb8pmz6vq0b5psfva5ld7gm3d0ibdxrzhw0f0rxgb9bqdh5h";
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

