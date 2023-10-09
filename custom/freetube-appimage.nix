# Override to make sure freetube gets installed correctly (electron wasn't working right)

{ config, pkgs, lib, ... }:

let
    freetube-appimage = (
        let
            app_name = "freetube";
            gh_user = "FreeTubeApp";
            gh_proj = "FreeTube";
            version = "0.19.1";
            hash = "03w10mnah9ppi0z1ykhapgb3r5j6s3ghbc2qhrnmqkcxa39nmndd";
        in pkgs.appimageTools.wrapType2 {
            name = "freetube";
            extraPkgs = pkgs: [];
            src = builtins.fetchurl {
                url = "https://github.com/${gh_user}/${gh_proj}/releases/download/v${version}-beta"
                    + "/${app_name}_${version}_amd64.AppImage";
                sha256 = "${hash}";
            };
        }
    );
in {
    environment.systemPackages = with pkgs; [
        freetube-appimage
    ];
}

