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

# Make sure user has sudo privilages.
sudo echo
if [[ $? -ne 0 ]]; then
    echo "This script needs sudo privilages to run" 1>&2
    exit 1
fi

#Install systemd scripts for decrypt HDD.
sudo cp "$PWD/etc/systemd/system/sysinit.target.wants/decrypt-hdd-disk.service" /etc/systemd/system/sysinit.target.wants/

#Install udev rules for ssh scheduler
sudo cp "$PWD/etc/udev/rules.d/60-ssd-scheduler.rules" /etc/udev/rules.d/

#Install fstrim service for ssh disk.
sudo cp "$PWD/etc/systemd/system/fstrim.service" /etc/systemd/system/

#Install redirection of user .cache
sudo cp "$PWD/etc/systemd/user/xdg-cache-home.service" /etc/systemd/user/

#Copy tmpfs-ccache files.
# TODO User privilages of tmp directory and copy ccache.conf
sudo cp "$PWD/thirdparty/tmpfs-ccache/etc/tmpfs-ccache" /etc/
sudo cp "$PWD/thirdparty/tmpfs-ccache/etc/systemd/system/tmpfs-ccache.service" /etc/systemd/system/
sudo cp "$PWD/thirdparty/tmpfs-ccache/usr/local/bin/tmpfs-ccache-service.sh" /usr/local/bin/
sudo cp "$PWD/thirdparty/tmpfs-ccache/usr/local/bin/tmpfs-ccache-user.sh" /usr/local/bin/

#Copy squash portage script
sudo cp "$PWD/thirdparty/squash-portage/squash-portage.sh" /usr/local/bin/

#TODO Layman
#TODO My local portage

# Install neovim and application needed for its plugins.
applications_to_merge="$applications_to_merge neovim zathura texlive"
# Install vim files
ln -s "$PWD/thirdparty/vim-conf" ~/.vim
mkdir -p ~/.config/nvim && ln -s "$PWD/thirdparty/vim-conf/init.vim" ~/.config/nvim/init.vim
# Install vim plugin dependencies
## InstantRst -> install server
pip install --user https://github.com/Rykka/instant-rst.py/archive/master.zip
# TODO install my changes on markdown viewer plugin

# Install ranger file system manager.
applications_to_merge="$applications_to_merge ranger"

# Install cron daemon to interrupt gpe12 for ssd disk in my toshiba.
applications_to_merge="$applications_to_merge vixie-cron"

#TODO Gnomeshell extensions
# GNOME Extensions
## Install taskwhisperer gnome extension
ln -s "$PWD/thirdparty/taskwhisperer" ~/.local/share/gnome-shell/extensions/taskwhisperer-extension@infinicode.de
## Install remove arrow gnome extension
ln -s "$PWD/thirdparty/gnome-shell-remove-dropdown-arrows" ~/.local/share/gnome-shell/extensions/remove-dropdown-arrows@mpdeimos.com
## Install text translator gnome extension
applications_to_merge="$applications_to_merge translate-shell"
ln -s "$PWD/translate-shell" ~/.config/translate-shell
ln -s "$PWD/thirdparty/text-translator" ~/.local/share/gnome-shell/extensions/text_translator@awamper.gmail.com
## Install jenkins indicator gnome extension
ln -s "$PWD/thirdparty/gnome3-jenkins-indicator" ~/.local/share/gnome-shell/extensions/jenkins-indicator@philipphoffmann.de

# Install oh-my-zsh and zsh-notify plugin
# TODO Install oh-my-zsh
applications_to_merge="$applications_to_merge xdotool"
ln -s "$PWD/thirdparty/zsh-notify" ~/.oh-my-zsh/custom/plugins/notify
ln -s "$PWD/thirdparty/zsh-mkc" ~/.oh-my-zsh/custom/plugins/mkc

# Install email, contacts
sudo mkdir /var/spool/richi_mail
sudo chown ricardo:ricardo /var/spool/richi_mail
ln -s /var/spool/richi_mail ~/.mail
## Install vdirsyncer
applications_to_merge="$applications_to_merge requests-oauthlib vdirsyncer"
mkdir "~/.vdirsyncer"
ln -s "$PWD/thirdparty/email-conf/vdirsyncer/config" ~/.vdirsyncer/config
sudo cp "$PWD/thirdparty/email-conf/vdirsyncer/vdirsyncer.service" /etc/systemd/user
sudo cp "$PWD/thirdparty/email-conf/vdirsyncer/vdirsyncer.timer" /etc/systemd/user
systemctl --user enable vdirsyncer.timer
## Install khard
applications_to_merge="$applications_to_merge khard"
mkdir ~/.config/khard/
ln -s "$PWD/thirdparty/email-conf/khard/khard.conf" ~/.config/khard/khard.conf
## Install offlineimap
applications_to_merge="$applications_to_merge offlineimap keyring"
ln -s "$PWD/thirdparty/email-conf/offlineimap/offlineimaprc" ~/.offlineimaprc
mkdir ~/.mail/offlineimap
ln -s "$PWD/thirdparty/email-conf/offlineimap/gnome-keyring-query.py" ~/.mail/offlineimap/gnome-keyring-query.py
sudo cp "$PWD/thirdparty/email-conf/offlineimap/offlineimap-oneshot.*" /etc/systemd/user
systemctl --user enable offlineimap-oneshot.timer
## Install notmuch
applications_to_merge="$applications_to_merge notmuch"
ln -s "$PWD/thirdparty/email-conf/notmuch/notmuch-config" ~/.notmuch-config
## Install notifymuch
pip3 install --user thirdparty/email-conf/thirdparty/notifymuch/
mkdir ~/.mail/mail/.notmuch
ln -s "$PWD/thirdparty/email-conf/notmuch/hooks" ~/.mail/mail/.notmuch/hooks
## Install msmtp
applications_to_merge="$applications_to_merge msmtp"
ln -s "$PWD/thirdparty/email-conf/msmtp/msmtprc" ~/.msmtprc
## Install mutt
applications_to_merge="$applications_to_merge mutt muttprint t-prot w3m extract_url"
mkdir ~/.mail/cache/headers
mkdir ~/.mail/cache/bodies
ln -s "$PWD/thirdparty/email-conf/mutt/muttrc" ~/.muttrc
ln -s "$PWD/thirdparty/email-conf/mutt/config" ~/.mutt
ln -s "$PWD/thirdparty/email-conf/mutt/extract_urlview" ~/.extract_urlview
ln -s "$PWD/thirdparty/email-conf/mutt/mutt-html-attach" ~/.local/bin/mutt-html-attach

#Show message about gnome-terminal-colors-solarized
echo "Executing thirdparty/gnome-terminal-colors-solarized/install.sh ..."
echo "    Note: remember this package can install also .dircolors"
read -t 10
sh -c "$PWD/thirdparty/gnome-terminal-colors-solarized/install.sh"

# Install powerline
echo 'Installing powerline...'
read -t 10
pip install --user powerline-status

# Install tmux configuration
ln -s "$PWD/tmux/tmux.conf" ~/.tmux.conf
ln -s "$PWD/tmux/tmux.desktop" ~/.local/share/applications/tmux.desktop
mkdir -p ~/.config/powerline/themes/tmux
ln -s "$PWD/tmux/default.json" ~/.config/powerline/themes/tmux/

# Install zsh configuration
ln -s "$PWD/zsh/zshenv" ~/.zshenv
ln -s "$PWD/zsh/zshrc" ~/.zshrc

#TODO Emerge syslog-ng logrotate task, thefuck
# TODO Install gitignore https://www.gitignore.io/

sudo emerge -va $applications_to_merge

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
#TODO Use systemd timer instead of cron

# Install taskwarrior hook
# TODO Remove?
cp "$PWD/thirdparty/taskwarrior-hamster-hook/on-modify.hamster" ~/.task/hooks/
# Install redminetimesync
cp "$PWD/thirdparty/redminetimesync/activities.config.tpl" "$PWD/thirdparty/redminetimesync/activities.config"
cp "$PWD/thirdparty/redminetimesync/redminetimesync.config.tpl" "$PWD/thirdparty/redminetimesync/redminetimesync.config"
echo "Include redmine key in redminetimesync.config ..."
read -t 10
nvim "$PWD/thirdparty/redminetimesync/redminetimesync.config"

#Show message about crontab and interrupt gpe12
echo 'Execute "crontab -e" and add next line:'
echo '    @reboot echo "disable" > /sys/firmware/acpi/interrupts/gpe12'

#Show message for vdirsyncer
echo 'vdirsyncer: store credentials in Gnome Keyring using python:'
echo '    python'
echo '    >>> import keyring'
echo '    >>> keyring.set_password("vdirsyncer", "personal_client_id" ,"[client_id]")'
echo '    >>> keyring.set_password("vdirsyncer", "personal_client_secret", "[client_secret]")'
echo '    >>> quit()'
echo 'vdirsyncer: create google credentials and execute:'
echo '    vdirsyncer discover'
echo '    vdirsyncer metasync'
#show message for offlineimap
echo 'offlineimap: create google app password for offlineimap and msmtp.'
echo 'offlineimap: store credentials in Gnome Keyring using python:'
echo '    python'
echo '    >>> import keyring'
echo '    >>> keyring.set_password("personal_gmail", "password" ,"[password]")'
echo '    >>> quit()'
#echo 'offlineimap: create google credentials following instructions on:'
#echo '    https://hobo.house/2017/07/17/using-offlineimap-with-the-gmail-imap-api/'
#echo 'offlineimap: store credentials in Gnome Keyring using python:'
#echo '    python'
#echo '    >>> import keyring'
#echo '    >>> keyring.set_password("offlineimap", "personal_client_id" ,"[client_id]")'
#echo '    >>> keyring.set_password("offlineimap", "personal_client_secret", "[client_secret]")'
#echo '    >>> keyring.set_password("offlineimap", "personal_refresh_token", "[refresh_token]")'
#echo '    >>> quit()'
echo 'offlineimap: first execution of offlineimap:'
echo '    offlineimap -o'
echo 'msmtp: store credentials in Gnome Keyring using python:'
echo '    secret-tool store --label=msmtp host smtp.gmail.com service smtp user correoricky@gmail.com'
