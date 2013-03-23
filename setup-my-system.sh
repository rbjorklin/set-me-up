#!/bin/bash

echo "Installing Development Tools"
sudo yum group install "Development Tools"
echo "Installing git, tmux..."
sudo yum install git tmux zsh vim-enhanced mosh levien-inconsolata-fonts xterm wget irssi task

echo "Setting up RPM-Fusion"
wget --content-disposition --user-agent="Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20100101 Firefox/19.0" "http://rpmfusion.org/keys?action=AttachFile&do=get&target=RPM-GPG-KEY-rpmfusion-nonfree-fedora-$(rpm -E %fedora)" -O RPM-GPG-KEY-rpmfusion-nonfree-fedora-$(rpm -E %fedora)
wget --content-disposition --user-agent="Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20100101 Firefox/19.0" "http://rpmfusion.org/keys?action=AttachFile&do=get&target=RPM-GPG-KEY-rpmfusion-free-fedora-$(rpm -E %fedora)" -O RPM-GPG-KEY-rpmfusion-free-fedora-$(rpm -E %fedora)
sudo rpm --import RPM-GPG-KEY-rpmfusion-free-fedora-$(rpm -E %fedora)
sudo rpm --import RPM-GPG-KEY-rpmfusion-nonfree-fedora-$(rpm -E %fedora)
sudo yum install http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

echo "Setting colemak for CLI"
sudo sed -i s/KEYMAP=".*"/KEYMAP=\"en-latin9\"/ /etc/vconsole.conf

echo "Setting up ZSH"
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
cp ./dotfiles/.zshrc ~/.zshrc
chsh -s /bin/zsh

echo "Setting up vim"
cp ./dotfiles/.vimrc ~/.vimrc

git clone git://github.com/altercation/solarized.git
mkdir ~/.vim
mv solarized/vim-colors-solarized/* ~/.vim
rm -rf solarized

echo "Fetching latest hosts file from someonewhocares"
wget http://someonewhocares.org/hosts/hosts
sudo mv hosts /etc/hosts

echo "Fetching Solarized .Xresources"
git clone git://github.com/solarized/xresources.git
mv xresources/solarized ~/.Xresources
rm -rf xresources

echo "xterm*.faceName: Inconsolata" >> ~/.Xresources
echo "xterm*.faceSize: 12" >> ~/.Xresources
echo "xterm*.geometry: 80x25" >> ~/.Xresources
echo "xterm*.scrollBar: false" >> ~/.Xresources
echo "Xft.dpi: 96" >> ~/.Xresources
echo "Xft.hintstyle: hintfull" >> ~/.Xresources
echo "Xft.hinting: true" >> ~/.Xresources

xrdb ~/.Xresources

echo "Fetching Solarized .dircolors"
git clone git://github.com/seebi/dircolors-solarized.git
mv dircolors-solarized/dircolors.256dark ~/.dircolors
rm -rf dircolors-solarized

echo "Fetching scala syntax highlighting and indentation for vim"
git clone https://github.com/scala/scala-dist.git
mv ~/scala-dist/tool-support/src/vim/* ~/.vim 
rm -rf ~/scala-dist

echo "Setting up tmux"
cp ./dotfiles/.tmux.conf ~/

echo "Setting up task"
cp ./dotfiles/.taskrc ~/

echo "Zenbook UX31 color profile"
echo "http://www.notebookcheck.net/uploads/tx_nbc2/UX31.icc"

echo "Basic setup should be done!"
