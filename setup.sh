#!/bin/bash -eu

shopt -s dotglob
rm -rf $HOME/.vim
rm -rf $HOME/.git
rm -rf $HOME/dircolors-solarized
cd $HOME/configs
git submodule foreach --recursive '[ -f .git ] && echo "gitdir: $(realpath --relative-to=. $(cut -d" " -f2 .git))" > .git' >/dev/null
cd $HOME
mv $HOME/configs/* $HOME/
rm -rf $HOME/configs
