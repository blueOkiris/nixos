# Set up VPN for National Instruments

{ config, pkgs, lib, ... }:

{
    # VPN
    environment.etc."ssl/certs/DigiCertGlobalRootG2.crt".source = ./DigiCertGlobalRootG2.crt;
    environment.etc."ssl/certs/DigiCertGlobalG2TLSRSASHA2562020CA1.crt ".source =
        ./DigiCertGlobalG2TLSRSASHA2562020CA1.crt;
    # Backup Manual method
    #services.strongswan = {
    #    enable = true;
    #    connections = {
    #        "%default" = {
    #            ikelifetime = "8h";
    #            reauth = "no";
    #            keylife = "20m";
    #            rekeymargin = "3m";
    #            #keyringtries = "1";
    #            keyexchange = "ikev2";
    #            mobike = "yes";
    #        };
    #        "ni-vpn" = {
    #            left = "%any";
    #            leftsourceip = "%config";
    #            leftfirewall = "yes";
    #            leftauth = "eap-mschapv2";
    #            right = "vpn-us1.natinst.com";
    #            rightid = "%vpn.natinst.com";
    #            rightsubnet = "0.0.0.0/0";
    #            rightdns = "172.18.18.80,172.18.20.80";
    #            auto = "add";
    #        };
    #    };
    #    ca = {
    #        ni-vpn-rsa = {
    #            auto = "add";
    #            cacert = "/etc/nixos/DigiCertGlobalG2TLSRSASHA2562020CA1.crt";
    #        };
    #        ni-vpn-cert = {
    #            auto = "add";
    #            cacert = "/etc/nixos/DigiCertGlobalRootG2.crt";
    #        };
    #    };
    #};
}

