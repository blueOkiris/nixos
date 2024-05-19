# Override to make sure cura is most recent version

{ config, pkgs, lib, ... }:

let
    cura-appimage = (
        let
            app_name = "cura";
            gh_user = "Ultimaker";
            gh_proj = "Cura";
            version = "5.7.1";
            hash = "0g01xbar432c1sjv70j4mri2avpg38wvsacv211jjk9wzb8h74rd";
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

