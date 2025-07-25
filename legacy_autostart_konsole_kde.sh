#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
konsole -e "pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY bash \"${SCRIPT_DIR}/amnesia_whitelist.sh\""