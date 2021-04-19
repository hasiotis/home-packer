#!/bin/bash -eux

# Add sysadmin user to sudoers.
echo "sysadmin        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers

sudo -u sysadmin mkdir /home/sysadmin/.ssh/

# Get updated
apt-get update && apt-get dist-upgrade -y && apt-get clean
DEBIAN_FRONTEND=noninteractive apt-get install -y less \
    links lynx lsof host htop make python3-requests cloud-init

rm -rf /var/lib/cloud/instance
