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
            strongswan stop
            exit
            ;;
    esac
done

strongswan start || true
sleep 1

strongswan start
strongswan stroke user-creds ni-vpn dturner
strongswan up ni-vpn

