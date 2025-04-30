#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
bash -c "pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY bash \"${SCRIPT_DIR}/amnesia_whitelist.sh\""
