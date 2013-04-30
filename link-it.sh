#!/bin/zsh

linkit () {
  DIR=`pwd`
  FILE=$1
  rm ~/.$FILE
  ln -s $PWD/$FILE ~/.$FILE
}

all () {
  linkit zshrc
  linkit taskrc
  linkit vimrc
  linkit tmux.conf
  linkit Xresources
  linkit dircolors
  linkit gitconfig
}

while getopts "haul:" opt; do
  case $opt in
  h) echo "usage: $0 [-h] [-a] [-u] file ..."; exit ;;
  a) all ;;
  u) echo "not implemented" ;;
  l) shift 1; linkit $1 ;;
  *) echo "incorrect usage"; exit ;;
  esac
done

