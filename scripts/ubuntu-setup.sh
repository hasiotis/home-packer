#!/bin/bash -eux

# Add sysadmin user to sudoers.
echo "sysadmin        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers

# Disable package-update-upgrade-install
sed -i "/^ - package-update-upgrade-install/d" /etc/cloud/cloud.cfg

sudo -u sysadmin mkdir /home/sysadmin/.ssh/
