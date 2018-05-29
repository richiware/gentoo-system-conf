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
echo "Executing thirdparty/gnome-terminal-colors-solarized/install.sh ..."
read -t 10
sh -c "$PWD/thirdparty/gnome-terminal-colors-solarized/install.sh"

# Install powerline
echo 'Installing powerline...'
read -t 10
pip install --user powerline-status

# Install vim files
ln -s "$PWD/thirdparty/vim-conf" ~/.vim
mkdir -p ~/.config/nvim && ln -s "$PWD/thirdparty/vim-conf/init.vim" ~/.config/nvim/init.vim

# Install tmux configuration
ln -s "$PWD/tmux/tmux.conf" ~/.tmux.conf
ln -s "$PWD/tmux/tmux.desktop" ~/.local/share/applications/tmux.desktop
mkdir -p ~/.config/powerline/themes/tmux
ln -s "$PWD/tmux/default.json" ~/.config/powerline/themes/tmux/

# Install zsh configuration
ln -s "$PWD/zsh/zshenv" ~/.zshenv
ln -s "$PWD/zsh/zshrc" ~/.zshrc

# Execute taskwarrior to create config file
echo "Creating configuration for taskwarrior..."
read -t 10
task list

# Install bugwarrior
cp "$PWD/bugwarrior/bugwarriorrc" ~/.bugwarriorrc
echo "Include redmine key in ~/.bugwarriorrc ..."
read -t 10
vim ~/.bugwarriorrc
echo "Include bugwarrior as cron job: add '0 8 * * * /usr/bin/bugwarrior-pull' ..."
read -t 10
sudo crontab -u $USER -e

# Install taskwarrior hook
cp "$PWD/thirdparty/taskwarrior-hamster-hook/on-modify.hamster" ~/.task/hooks/

# Install redminetimesync
cp "$PWD/thirdparty/redminetimesync/activities.config.tpl" "$PWD/thirdparty/redminetimesync/activities.config"
cp "$PWD/thirdparty/redminetimesync/redminetimesync.config.tpl" "$PWD/thirdparty/redminetimesync/redminetimesync.config"
echo "Include redmine key in redminetimesync.config ..."
read -t 10
vim "$PWD/thirdparty/redminetimesync/redminetimesync.config"

# Install taskwhisperer gnome extension
ln -s "$PWD/thirdparty/taskwhisperer" ~/.local/share/gnome-shell/extensions/taskwhisperer-extension@infinicode.de

# Install remove arrow gnome extension
ln -s "$PWD/thirdparty/gnome-shell-remove-dropdown-arrows" ~/.local/share/gnome-shell/extensions/remove-dropdown-arrows@mpdeimos.com

# Install text translator gnome extension
ln -s "$PWD/thirdparty/text-translator" ~/.local/share/gnome-shell/extensions/text_translator@awamper.gmail.com

# Install jenkins indicator gnome extension
ln -s "$PWD/thirdparty/gnome3-jenkins-indicator" ~/.local/share/gnome-shell/extensions/jenkins-indicator@philipphoffmann.de

# Install oh-my-zsh and zsh-notify plugin
# TODO Install oh-my-zsh
sudo emerge -va xdotool
ln -s "$PWD/thirdparty/zsh-notify" ~/.oh-my-zsh/custom/plugin/notify
