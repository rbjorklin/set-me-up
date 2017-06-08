#!/bin/sh

if [[ $# -ne 2 ]] ; then
    echo "You need to supply both a user name and a setup type."
    echo "$0 [<user>|n/a] [desktop|server|slim]"
    exit 1
fi

sudo mkdir -p /etc/salt/minion.d
sudo cp /srv/local.conf /etc/salt/minion.d/
sudo dnf install -y salt-minion
echo "Starting salt state, this might take a few minutes."
sudo salt-call -l quiet state.highstate pillar="{'user':'$1','type':'$2'}"
