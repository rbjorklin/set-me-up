#!/bin/bash

cd ~/

echo "Installing Development Tools"
sudo yum group install "Development Tools"
echo "Installing git, tmux..."
sudo yum install git tmux zsh vim-enhanced mosh levien-inconsolata-fonts xterm wget

echo "Setting up ZSH"
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
sed -i s/robbyrussell/blinks/ ~/.zshrc
sed -i s/\(git\)/\(git\ yum\)/ ~/.zshrc
chsh -s /bin/zsh

echo "Setting up vim"
cp /etc/vimrc ~/.vimrc

echo "set background=dark" > ~/.vimrc
echo "colors solarized" > ~/.vimrc
echo "set tabstop=2" > ~/.vimrc
echo "set expandtab" > ~/.vimrc
echo "set shiftwidth=2" > ~/.vimrc
echo "set number" > ~/.vimrc

git clone git://github.com/altercation/solarized.git
mkdir ~/.vim
cp solarized/vim-colors-solarized/* ~/.vim
rm -rf solarized

echo "Fetching latest hosts file from someonewhocares"
wget http://someonewhocares.org/hosts/hosts
sudo mv hosts /etc/hosts

echo "Fetching Solarized .Xresources"
git clone git://github.com/solarized/xresources.git
cp xresources/solarized ~/.Xresources
rm -rf xresources

echo "xterm*.faceName: Inconsolata" > ~/.Xresources
echo "xterm*.faceSize: 12" > ~/.Xresources
echo "xterm*.geometry: 80x25" > ~/.Xresources
echo "xterm*.scrollBar: false" > ~/.Xresources
echo "Xft.dpi: 96" > ~/.Xresources
echo "Xft.hintstyle: hintfull" > ~/.Xresources
echo "Xft.hinting: true" > ~/.Xresources

echo "Fetching Solarized .dircolors"
git clone git://github.com/seebi/dircolors-solarized.git
cp dircolors-solarized/dircolors.256dark ~/.dircolors
rm -rf dircolors-solarized

echo "Zenbook UX31 color profile"
echo "http://www.notebookcheck.net/uploads/tx_nbc2/UX31.icc"

echo "Basic setup should be done!"
