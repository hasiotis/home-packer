#!/bin/bash -eux

# Apt cleanup.
apt-get autoremove -y
apt-get update

#clear audit logs
if [ -f /var/log/audit/audit.log ]; then
    cat /dev/null > /var/log/audit/audit.log
fi
if [ -f /var/log/wtmp ]; then
    cat /dev/null > /var/log/wtmp
fi
if [ -f /var/log/lastlog ]; then
    cat /dev/null > /var/log/lastlog
fi

#cleanup persistent udev rules
if [ -f /etc/udev/rules.d/70-persistent-net.rules ]; then
    rm /etc/udev/rules.d/70-persistent-net.rules
fi

#cleanup /tmp directories
rm -rf /tmp/*
rm -rf /var/tmp/*

#cleanup current ssh keys
rm -f /etc/ssh/ssh_host_*

#reset hostname
cat /dev/null > /etc/hostname

#cleanup apt
apt-get clean

#cleanup shell history
history -w
history -c

# Delete unneeded files.
rm -f /home/sysadmin/*.sh

# Cleanup cloud-init
cloud-init clean --logs

# Add `sync` so Packer doesn't quit too early, before the large file is deleted.
sync
