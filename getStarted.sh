#!/bin/sh

# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

sudo dnf install -y ansible
sudo ansible-playbook -e user=$USER --diff playbook.yaml

# Disable websites taking over browser shortscuts/hotkeys
# https://support.mozilla.org/en-US/questions/1241294
echo "Set 'permissions.default.shortcuts=2' in Firefox about:config"
