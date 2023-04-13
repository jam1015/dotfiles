# Jordan's Dot Files

This file is located on in Jordan Mandel's home directory in any of his unix systems.

- Neovim Config
- Chemacs2 with Spacemacs and Doom
- zshrc
- `.Rprofile`
- etc

They are maintained in a git bare repo.  The script for automating this is in [this repo](https://github.com/jam1015/clone_dotfiles).

The idea is that the dotfiles are kept in the bare git repo `~/dotfiles.vim`.  Then the command `dots` is aliased to `/usr/bin/git --git-dir=$HOME/dotfiles.git --work-tree=$HOME` so that we can use it in place of the `git` command in the home directory but still keep other git repos under the home directory. This alias is first applied in the bash script in the `clone_dotfiles` repo, and also included in my bashrc and zshrc for further use.
