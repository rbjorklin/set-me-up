#!/bin/sh

# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

USER=$1

sudo mkdir -p /etc/salt/minion.d
sudo cp /srv/local.conf /etc/salt/minion.d/
sudo dnf install -y salt-minion
echo "Starting salt state, this might take a few minutes."
sudo salt-call -l quiet state.highstate pillar="{'user':'$USER'}"
