#!/bin/bash

wget -q --content-disposition --user-agent="Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20100101 Firefox/19.0" "http://rpmfusion.org/keys?action=AttachFile&do=get&target=RPM-GPG-KEY-rpmfusion-nonfree-fedora-$(rpm -E %fedora)" -O RPM-GPG-KEY-rpmfusion-nonfree-fedora-$(rpm -E %fedora)
wget -q --content-disposition --user-agent="Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20100101 Firefox/19.0" "http://rpmfusion.org/keys?action=AttachFile&do=get&target=RPM-GPG-KEY-rpmfusion-free-fedora-$(rpm -E %fedora)" -O RPM-GPG-KEY-rpmfusion-free-fedora-$(rpm -E %fedora)
rpm --import RPM-GPG-KEY-rpmfusion-free-fedora-$(rpm -E %fedora)
rpm --import RPM-GPG-KEY-rpmfusion-nonfree-fedora-$(rpm -E %fedora)
rm RPM-GPG-KEY-rpmfusion-*free-fedora-$(rpm -E %fedora)
dnf install http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
