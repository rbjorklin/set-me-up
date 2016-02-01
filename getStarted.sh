#!/bin/sh

sudo mkdir -p /etc/salt/minion.d
sudo cp /srv/files/local.conf /etc/salt/minion.d/
sudo dnf install -y salt-minion
sudo salt-call -l quiet state.highstate
