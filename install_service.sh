#!/bin/bash

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

mkdir /opt/AmneziaVPN_WhiteList_Service
cp $SCRIPT_DIR/amnezia_whitelist.sh /opt/AmneziaVPN_WhiteList_Service/amnesza_whitelist.sh
cp $SCRIPT_DIR/amnezia_whitelist.service /etc/systemd/system/amnezia_whitelist.service

systemctl enable --now amnezia_whitelist
systemctl status amnezia_whitelist
