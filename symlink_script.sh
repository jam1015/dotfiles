#!/bin/bash
cd ..
for fle in ./dotfiles/.*
do
	if [ "$fle" != './dotfiles/..' ] && [ "$fle" != './dotfiles/.' ]
	then
		base=$(basename "$fle")
		ln -s $fle $base
	fi
done
cd -
