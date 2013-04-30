#!/bin/zsh

link () {
  DIR=`pwd`
  FILE=$1
  rm ~/.$FILE
  ln -s $PWD/$FILE ~/.$FILE
}

link zshrc
link taskrc
link vimrc
link tmux.conf
link Xresources
link dircolors
link gitconfig
