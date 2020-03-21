#!/bin/sh

# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

sudo mkdir -p /etc/salt/minion.d
sudo cp /srv/local.conf /etc/salt/minion.d/
sudo dnf install -y salt-minion
echo "Starting salt state, this might take a few minutes."
sudo salt-call -l quiet state.apply set-me-up pillar="{'user':'$USER'}"


# Disable websites taking over browser shortscuts/hotkeys
# https://support.mozilla.org/en-US/questions/1241294
echo "Set 'permissions.default.shortcuts=2' in Firefox about:config"
