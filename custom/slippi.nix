# Package up the Slippi AppImage

{ config, pkgs, lib, ... }:

let
    slippi = (
        let
            app_name = "Slippi_Online-x86_64.AppImage";
            gh_proj = "Ishiiruka";
            gh_user = "project-slippi";
            version = "3.3.1";
            hash = "15hidprq7x0i26wlq11xw28nsawz0wabg6cfqh25rznnqc6kczax";
        in pkgs.appimageTools.wrapType2 {
            name = "slippi";
            extraPkgs = pkgs: [
                pkgs.gmp
                pkgs.mpg123
                pkgs.libmpg123
                pkgs.curl
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
        slippi
    ];
}

