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
echo "Executing thirdparty/gnome-terminal-colors-solarized/install.sh"
read -t 10
sh -c "$PWD/thirdparty/gnome-terminal-colors-solarized/install.sh"

# Install vim files
ln -s "$PWD/thirdparty/vim-conf" ~/.vim
mkdir -p ~/.config/nvim && ln -s "$PWD/thirdparty/vim-conf/init.vim" ~/.config/nvim/init.vim

# Install tmux configuration
ln -s "$PWD/tmux/tmux.conf" ~/.tmux.conf
ln -s "$PWD/tmux/tmux.desktop" ~/.local/share/applications/tmux.desktop

# Install zsh configuration
ln -s "$PWD/zsh/zshenv" ~/.zshenv
ln -s "$PWD/zsh/zshrc" ~/.zshrc

# Execute taskwarrior to create config file
task list

# Install bugwarrior
cp "$PWD/bugwarrior/bugwarriorrc" ~/.bugwarriorrc
echo "Include redmine key in ~/.bugwarriorrc"
read -t 10
vim ~/.bugwarriorrc

# Install redminetimesync
cp "$PWD/thirdparty/redminetimesync/activities.config.tpl" "$PWD/thirdparty/redminetimesync/activities.config"
cp "$PWD/thirdparty/redminetimesync/redminetimesync.config.tpl" "$PWD/thirdparty/redminetimesync/redminetimesync.config"
echo "Include redmine key in redminetimesync.config"
read -t 10
vim "$PWD/thirdparty/redminetimesync/redminetimesync.config"

# Install taskwhisperer gnome extension
ln -s "$PWD/thirdparty/taskwhisperer" ~/.local/share/gnome-shell/extensions/taskwhisperer-extension@infinicode.de
