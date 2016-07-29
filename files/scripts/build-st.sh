#!/bin/bash

TMP=$(mktemp -d)
cd $TMP
git clone git://git.suckless.org/st ./

COMMIT=$(git rev-parse --short HEAD)
NO_BOLD=$(curl -s http://st.suckless.org/patches/solarized | grep -oe ">st-no_bold_colors-[0-9]\+-${COMMIT}.diff<" | tr -d "<>")
SOL_DARK=$(curl -s http://st.suckless.org/patches/solarized | grep -oe ">st-solarized-dark-[0-9]\+-${COMMIT}.diff<" | tr -d "<>")

curl -s -O http://st.suckless.org/patches/${NO_BOLD}
curl -s -O http://st.suckless.org/patches/${SOL_DARK}

cp /srv/files/st/config.def.h.patch ./
patch < ${NO_BOLD}
patch < ${SOL_DARK}
patch < config.def.h.patch

make clean install
cp /srv/files/st/st.desktop /usr/share/applications/

cd /
rm -rf $TMP
