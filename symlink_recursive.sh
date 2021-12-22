#!/bin/bash

# script meant to be kept in my dotfiles to recursively link the files to the home directory
# clone the dotfiles repo to ~
# then run this script to recursively copy all of the files
# TODO use basename in declaration of loop rather than inside the loop
# look up `--` syntax used with basename

recursive_ln()
{
	# these two conditions test if one is a file and the other is a directory or vice-versa
	echo ====================================================
	echo "trying to link $1 and $2"

	if    [ -d "$1" ] && [ -f "$2" ]
	then
		echo "type mismatch between $1 (directory) and $2 (file)"
		return 0
	fi

	if  [ -f "$1" ] && [ -d "$2" ]
	then
		echo "type mismatchbetween $1 (file) and $2 (directory)"
		return 0
	fi

	# seeing whether they are both files
	if [ -f "$1" ] && [ -f "$2" ]
	then
		echo "both files, not symlinking"
	fi

	# checking if the file already exists

	if [ -d "$1" ] && [ -d "$2" ]
	then
		echo "both directories: recursively symlinking contents"
		for fle in "$1"/.*
		do
			echo "file is $fle"
			fle_used="$(basename -- $fle)"
			echo "basename is $fle_used"
			if [ "$fle_used" != '..' ] && [ "$fle_used" != '.' ] && [ "$fle_used" != 'symlink_recursive.sh' ] && [ fle_used!="dotfiles" ] && [ fle_used!="README.md" ]
			then
				echo "applying recursion"
				recursive_ln "$1/$fle_used" "$2/$fle_used"
			else
				echo "file rejected for recursion"
			fi
		done
	fi

	echo "linking $1 to $2"
	#ln -sv $1 $2
	return 0
}

recursive_ln ~/dotfiles ~
