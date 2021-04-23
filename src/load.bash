#!/usr/bin/env bash

## To get all functions : bash -c "source src/load.bash && declare -F"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=/dev/null
source "$SCRIPT_DIR/common/os.bash"
# shellcheck source=/dev/null
source "$SCRIPT_DIR/common/multipass.bash"
# shellcheck source=/dev/null
source "$SCRIPT_DIR/common/tektoncd.bash"

# shellcheck source=/dev/null
source "$SCRIPT_DIR/cli/multipass.bash"
# shellcheck source=/dev/null
source "$SCRIPT_DIR/cli/microk8s.bash"
# shellcheck source=/dev/null
source "$SCRIPT_DIR/cli/k3d.bash"
