# Package a working Tutanota AppImage (electron was broken)

{ config, pkgs, lib, ... }:

let
    tutanota-appimage = (
        let
            app_name = "tutanota-desktop-linux";
            gh_user = "tutao";
            gh_proj = "tutanota";
            version = "252.241122.0";
            hash = "1ff164lnxjzsk8hq4r73nfhmk0k9hdqk3g179lypcy2spf3cqzwp";
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

