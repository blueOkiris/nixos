#!/bin/sh
# Author(s): Dylan Turner <dylan.turner@tutanota.com>
# Description: Connect to NI VPN

# Require sudo
if [[ $(id -u) -ne 0 ]]; then
    echo "The vpn requires root privileges to start."
    exit 1
fi

while [[ $# -gt 0 ]]; do
    case $1 in
        -s|--stop)
            ipsec stop
            exit
            ;;
    esac
done

ipsec start || true
sleep 1

ipsec start
ipsec stroke user-creds ni-vpn dturner
ipsec up ni-vpn

