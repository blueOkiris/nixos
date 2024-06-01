# Download and set up Project+'s AppImage

{ config, pkgs, lib, ... }:

let
    projectplus = (
        let
            app_name = "Faster_Project_Plus-x86-64.AppImage";
            gh_proj = "FPM-AppImage";
            gh_user = "jlambert360";
            version = "2.5.2";
            hash = "10ysd2d209bzvga8axjmxs69j3lg8j6gpjwakpkh3wv3w0wv8d57";
        in pkgs.appimageTools.wrapType2 {
            name = "project+";
            extraPkgs = pkgs: [
                pkgs.gmp
                pkgs.mpg123
                pkgs.libmpg123
                pkgs.webkitgtk
                pkgs.libthai
            ];
            src = builtins.fetchurl {
                url =
                    "https://github.com/${gh_user}/${gh_proj}/releases/download/"
                        + "v${version}/${app_name}";
                sha256 = "${hash}";
            };
        }
    );
in {
    environment.systemPackages = with pkgs; [
        projectplus
    ];
}

