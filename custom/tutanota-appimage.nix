# Package a working Tutanota AppImage (electron was broken)

{ config, pkgs, lib, ... }:

let
    tutanota-appimage = (
        let
            app_name = "tutanota-desktop-linux";
            gh_user = "tutao";
            gh_proj = "tutanota";
            version = "246.241008.0";
            hash = "02kijcwl4rpjc56vsr800psqyhzk5sw74sdj83b0rpbijc0fs6s1";
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

