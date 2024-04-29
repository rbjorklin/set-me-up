#!/bin/env sh
DIR=~/.fzf-launcher/bin
ls -1 ${DIR} | \
	fzf \
	--border rounded \
	--bind "enter:execute(${DIR}/{})+abort" \
	--preview="cat ${DIR}/{}"
