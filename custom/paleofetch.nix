# Build paleofetch package from my git repo

{ config, pkgs, lib, ... }:

let
    paleofetch = pkgs.stdenv.mkDerivation rec {
        name = "paleofetch";
        src = pkgs.fetchFromGitHub {
            owner = "blueOkiris";
            repo = "paleofetch-nixos";
            rev = "a1e1a2f1f9d778d836c8d9bfaa8d44ddf8d2da4e";
            sha256 = "1a00n2kq5d9i2sw2fblac1n7ml48xj4zilrsqabayjnjf67vh5zn";
        };
        buildInputs = [ pkgs.gcc pkgs.gnumake pkgs.pciutils pkgs.xorg.libX11 ];
        buildPhase = ''
            mkdir -p $out
            cp -ra $src/* $out
            cd $out
            make
            rm -rf obj/
        '';
        installPhase = ''
            mkdir -p $out/bin
            cp $out/paleofetch $out/bin
        '';
    };
in {
    environment.systemPackages = with pkgs; [
        paleofetch
    ];
}

