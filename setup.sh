#!/bin/sh -eu

shopt -s dotglob
rm -rf $HOME/.vim
mv $HOME/configs/* $HOME/
rm -rf $HOME/configs
cd $HOME
