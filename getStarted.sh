#!/bin/sh

# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

sudo mkdir -p /etc/salt/minion.d
sudo cp /srv/local.conf /etc/salt/minion.d/
curl -L https://bootstrap.saltstack.com | sudo sh -s -- -P -x python3 git v2019.2.2
echo "Starting salt state, this might take a few minutes."
sudo salt-call -l quiet state.apply set-me-up pillar="{'user':'$USER'}"
