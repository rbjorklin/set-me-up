#!/bin/bash

# upgrade vim-plug, update plugins, upgrade again (why is this recommended?) and 
# finally check for uninstalled plugins
nvim --headless -c PlugUpgrade -c PlugUpdate -c PlugUpgrade -c PlugInstall &
NPID=$!
sleep 15
kill $NPID
