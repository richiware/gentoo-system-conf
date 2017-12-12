#!/bin/sh

#### Check preconditions ####

if [ -z "$(ls -A $PWD/thirdparty)" ]; then
    echo "First step, update git submodule"
    exit -1
fi

if [[ -d ~/.vim ]]; then
    echo "~/.vim directory already exists"
    exit -1
fi

#### Installation ####

#TODO Gnomeshell extensions

ln -s "$PWD/thirdparty/dircolors-solarized/dircolors.256dark" ~/.dircolors

#Show message about gnome-terminal-colors-solarized
echo "Execute thirdparty/gnome-terminal-colors-solarized/install.sh"

# Install vim files
ln -s "$PWD/thirdparty/vim-conf" ~/.vim
mkdir -p ~/.config/nvim && ln -s "$PWD/thirdparty/vim-conf/init.vim" ~/.config/nvim/init.vim

# Install tmux configuration
ln -s "$PWD/tmux/tmux.conf" ~/.tmux.conf
ln -s "$PWD/tmux/tmux.desktop" ~/.local/share/applications/tmux.desktop

# Install zsh configuration
ln -s "$PWD/zsh/zshenv" ~/.zshenv
ln -s "$PWD/zsh/zshrc" ~/.zshrc

# TODO Ejecutar comando taskwarrior para inicializar configuración

# Install bugwarrior
cp "$PWD/bugwarrior/bugwarriorrc" ~/.bugwarriorrc
echo "Configure ~/.bugwarriorrc"

# Install taskwhisperer gnome extension
ln -s "$PWD/thirdparty/taskwhisperer" ~/.local/share/gnome-shell/extensions/taskwhisperer-extension@infinicode.de
