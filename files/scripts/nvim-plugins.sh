#!/bin/bash
nvim --headless +PlugInstall &
NPID=$!
sleep 5
kill $NPID
