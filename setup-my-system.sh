#!/bin/bash

SCRIPT=`basename $0`
if [ ! -e `pwd`/$SCRIPT ] ; then
  echo "Not running from within git, exiting."
  exit 1
fi

echo "Installing wget"
sudo dnf install wget

echo "Setting up RPM-Fusion"
wget --content-disposition --user-agent="Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20100101 Firefox/19.0" "http://rpmfusion.org/keys?action=AttachFile&do=get&target=RPM-GPG-KEY-rpmfusion-nonfree-fedora-$(rpm -E %fedora)" -O RPM-GPG-KEY-rpmfusion-nonfree-fedora-$(rpm -E %fedora)
wget --content-disposition --user-agent="Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20100101 Firefox/19.0" "http://rpmfusion.org/keys?action=AttachFile&do=get&target=RPM-GPG-KEY-rpmfusion-free-fedora-$(rpm -E %fedora)" -O RPM-GPG-KEY-rpmfusion-free-fedora-$(rpm -E %fedora)
sudo rpm --import RPM-GPG-KEY-rpmfusion-free-fedora-$(rpm -E %fedora)
sudo rpm --import RPM-GPG-KEY-rpmfusion-nonfree-fedora-$(rpm -E %fedora)
sudo dnf install http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

echo "Installing good to have applications"
sudo dnf install \
  git tmux zsh ctags ctags-etags mosh levien-inconsolata-fonts \
  irssi task transmission-cli transmission-gtk vlc firefox

echo "Setting colemak for CLI"
sudo sed -i s/KEYMAP=".*"/KEYMAP=\"en-latin9\"/ /etc/vconsole.conf

echo "Setting up ZSH"
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
./link-it.sh -l zshrc
chsh -s /bin/zsh

#echo "Setting up vim"
#./link-it.sh -l vimrc
#mkdir -p ~/.vim/bundle
#git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
#vim +BundleInstall +qall

echo "Fetching latest hosts file from someonewhocares"
sudo wget http://someonewhocares.org/hosts/zero/hosts -O /etc/hosts

echo "Setting up Solarized .Xresources"
./link-it.sh -l Xresources
xrdb ~/.Xresources

# No longer needed?
#echo "Fetching Solarized .dircolors"
#git clone git://github.com/seebi/dircolors-solarized.git
#mv dircolors-solarized/dircolors.256dark ~/.dircolors
#rm -rf dircolors-solarized

echo "Setting up tmux"
./link-it.sh -l tmux.conf

echo "Setting up task"
./link-it.sh -l taskrc

echo "Zenbook UX31 color profile is included in this git"

echo "Basic setup should be done!"
