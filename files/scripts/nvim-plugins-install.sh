#!/bin/bash

# YouCompleteMe is huge with several submodules and took 65 sec on last benchmark.
# Might fail and will need git submodule update --init --recursive
# See: https://github.com/Valloric/YouCompleteMe#full-installation-guide
nvim --headless -c PlugInstall YouCompleteMe &
NPID=$!
sleep 75
kill $NPID

nvim --headless -c PlugInstall &
NPID=$!
sleep 10
kill $NPID
