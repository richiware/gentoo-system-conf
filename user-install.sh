#!/bin/sh

#### Check preconditions ####

if [[ -d ~/.vim ]]; then
    echo "~/.vim directory already exists"
    exit -1
fi

#### Installation ####

ln -s "$PWD/thirdparty/dircolors-solarized/dircolors.256dark" ~/.dircolors

#Show message about gnome-terminal-colors-solarized
echo "Execute thirdparty/gnome-terminal-colors-solarized/install.sh"

# Install vim files
ln -s "$PWD/thirdparty/vim-conf" ~/.vim
mkdir -p ~/.config/nvim && ln -s "$PWD/thirdparty/vim-conf/init.vim" ~/.config/nvim/init.vim
