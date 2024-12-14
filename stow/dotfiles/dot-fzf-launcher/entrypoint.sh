#!/bin/env sh
DIR=~/.fzf-launcher/bin
cd ${DIR}
ls --sort=time --time=atime -1 | \
	fzf \
	--border rounded \
	--bind "enter:execute(touch {} ; ./{})+abort" \
	--preview="cat {}"
