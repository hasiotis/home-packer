#!/bin/bash -eux

# Install some common packages
apt-get update
apt-get dist-upgrade -y
apt-get install -y \
    rsync less mc acl curl links lynx vim lsof ssh host \
    htop ntp mutt git-core iotop make zip unzip \
    sysstat dstat httpie jq python3-pip
apt-get autoremove --purge -y

# Add sysadmin user to sudoers.
echo "sysadmin        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers

# Disable package-update-upgrade-install
sed -i "/^ - package-update-upgrade-install/d" /etc/cloud/cloud.cfg

sudo -u sysadmin mkdir /home/sysadmin/.ssh/
