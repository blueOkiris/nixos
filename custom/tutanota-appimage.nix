# Package a working Tutanota AppImage (electron was broken)

{ config, pkgs, lib, ... }:

let
    tutanota-appimage = (
        let
            app_name = "tutanota-desktop-linux";
            gh_user = "tutao";
            gh_proj = "tutanota";
            version = "3.118.4";
            hash = "0rvcsyichrvfc3qp8c0vxmpmsxcrvm2hz34mr1w41r4agxgip7zq";
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

