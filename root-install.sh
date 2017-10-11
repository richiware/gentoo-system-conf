#!/bin/sh

# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

#Install systemd scripts for decrypt HDD.
cp "$PWD/etc/systemd/system/sysinit.target.wants/decrypt-hdd-disk.service" /etc/systemd/system/sysinit.target.wants/

#Install udev rules for ssh scheduler
cp "$PWD/etc/udev/rules.d/60-ssd-scheduler.rules" /etc/udev/rules.d/

#Install fstrim service for ssh disk.
cp "$PWD/etc/systemd/system/fstrim.service" /etc/systemd/system/

#Install redirection of user .cache
cp "$PWD/etc/systemd/user/xdg-cache-home.service" /etc/systemd/user/

#Copy tmpfs-ccache files.
cp "$PWD/thirdparty/tmpfs-ccache/etc/tmpfs-ccache" /etc/
cp "$PWD/thirdparty/tmpfs-ccache/etc/systemd/system/tmpfs-ccache.service" /etc/systemd/system/
cp "$PWD/thirdparty/tmpfs-ccache/usr/local/bin/tmpfs-ccache-service.sh" /usr/local/bin/
cp "$PWD/thirdparty/tmpfs-ccache/usr/local/bin/tmpfs-ccache-user.sh" /usr/local/bin/

#Copy squash portage script
cp "$PWD/thirdparty/squash-portage/squash-portage.sh" /usr/local/bin/

#Show message about crontab and interrupt gpe12
echo 'Execute "crontab -e" and add next line:'
echo '    @reboot echo "disable" > /sys/firmware/acpi/interrupts/gpe12'

# Install powerline
echo 'Install powerline:'
echo '    pip install --user powerline-status'
