#!/bin/sh

if [[ $# -ne 2 ]] ; then
    echo "You need to supply both a user name and a setup type [desktop|server]"
    echo "I.E. $0 alice desktop"
    exit 1
fi

sudo mkdir -p /etc/salt/minion.d
sudo cp /srv/files/local.conf /etc/salt/minion.d/
sudo dnf install -y salt-minion
sudo salt-call -l quiet state.highstate pillar=\'\{\"user\":\"$1\",\"type\":\"$2\"\}\'
