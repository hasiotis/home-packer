#!/bin/bash -eux

# Add sysadmin user to sudoers.
echo "sysadmin        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers

sudo -u sysadmin mkdir /home/sysadmin/.ssh/

# Get updated
apt-get update && apt-get dist-upgrade -y && apt-get clean
DEBIAN_FRONTEND=noninteractive apt-get install -y rsync less \
    mc acl curl links lynx vim lsof ssh host \
    htop ntp mutt git-core iotop make zip unzip sysstat tshark \
    python3-netaddr python3-pip python3-requests dstat lvm2 cloud-init
