#!/bin/bash

ST_VER=0.6

TMP=$(mktemp -d)
cd $TMP

curl -s -o st-${ST_VER}.tar.gz http://dl.suckless.org/st/st-${ST_VER}.tar.gz
tar -xzf st-${ST_VER}.tar.gz
cd st-${ST_VER}
curl -s -o st-${ST_VER}-solarized-dark.diff http://st.suckless.org/patches/st-${ST_VER}-solarized-dark.diff
curl -s -o st-${ST_VER}-no-bold-colors.diff http://st.suckless.org/patches/st-${ST_VER}-no-bold-colors.diff
cp /srv/files/st/config.def.h.patch ./
patch < st-${ST_VER}-no-bold-colors.diff
patch < st-${ST_VER}-solarized-dark.diff
patch < config.def.h.patch

make clean install
cp /srv/files/st/st*.desktop /usr/share/applications/
cd /
rm -rf $TMP
