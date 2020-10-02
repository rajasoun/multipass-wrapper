#!/usr/bin/env bash

## To get all functions : bash -c "source src/load.bash && declare -F"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=dev-tools/src/_seeker.bash
source "$SCRIPT_DIR/_installer.bash"
# shellcheck source=dev-tools/src/lib/os.bash
source "$SCRIPT_DIR/common/os.bash"
# shellcheck source=dev-tools/src/lib/os.bash
source "$SCRIPT_DIR/common/multipass.bash"
