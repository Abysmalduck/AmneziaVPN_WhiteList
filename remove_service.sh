#!/bin/bash

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)


systemctl disable amnezia_whitelist
systemctl stop amnezia_whitelist
systemctl status amnesia_whitelist

rm /opt/AmneziaVPN_WhiteList_Service/amnesia_whitelist.sh
rm -r /opt/AmneziaVPN_WhiteList_Service
rm /etc/systemd/system/amnesia_whitelist.service
