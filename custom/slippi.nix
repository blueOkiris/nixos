# Package up the Slippi AppImage

{ config, pkgs, lib, ... }:

let
    slippi = (
        let
            app_name = "Slippi_Online-x86_64.AppImage";
            gh_user = "project-slippi";
            gh_proj = "Ishiiruka";
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
    slippi-launcher = (
        let
            app_name = "";
            gh_user = "project-slippi";
            gh_proj = "project-slippi";
            version = "2.11.1";
            hash = "16vm445ikiwddy36x9dwjins45wxjdw4vrcv2m3s3g8bwdwivp0j";
        in pkgs.appimageTools.wrapType2 {
            name = "slippi-launcher";
            extraPkgs = pkgs: [
            ];
            src = builtins.fetchurl {
                url =
                    "https://github.com/${gh_user}/${gh_proj}/releases/download/"
                        + "v${version}/Slippi-Launcher-2.11.1-x86_64.AppImage";
                sha256 = "${hash}";
            };
        }
    );
in {
    environment.systemPackages = with pkgs; [
        slippi
        slippi-launcher
    ];
}

