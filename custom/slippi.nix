# Package up the Slippi AppImage

{ config, pkgs, lib, ... }:

let
    slippi = (
        let
            app_name = "Slippi_Online-x86_64.AppImage";
            gh_user = "project-slippi";
            gh_proj = "Ishiiruka";
            version = "3.4.1";
            hash = "1810jwmnia73gy9b4am3q5bmafmsl0sbdm7biw1lq7znfs335k9n";
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
            hash = "1qk648pag2piw4glz9p9zlb0jf2307r49gx5zvnzk390hn51yy2b";
        in pkgs.appimageTools.wrapType2 {
            name = "slippi-launcher";
            extraPkgs = pkgs: [
            ];
            src = builtins.fetchurl {
                url =
                    "https://github.com/${gh_user}/${gh_proj}/releases/download/"
                        + "v${version}/Slippi-Launcher-2.11.4-x86_64.AppImage";
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

