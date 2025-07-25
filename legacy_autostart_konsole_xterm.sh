#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
xterm -hold -e "pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY bash \"${SCRIPT_DIR}/amnesia_whitelist.sh\""