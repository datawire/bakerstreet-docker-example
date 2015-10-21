#!/bin/bash

# Update the system
sudo yum -y update

# ----------------------------------------------------------------------------------------------------------------------
# Datawire
# ----------------------------------------------------------------------------------------------------------------------

curl -s https://packagecloud.io/install/repositories/datawire/stable/script.rpm.sh | sudo bash
sudo yum -y install datawire-directory

IP="$(/sbin/ifconfig enp0s3 | grep 'inet\ ' | cut -d: -f2 | awk '{ print $2}')"
sed -i "s/directory_host: localhost/directory_host: ${IP}/g" /etc/datawire/datawire.conf

sudo systemctl enable directory
sudo systemctl start directory

# ----------------------------------------------------------------------------------------------------------------------
# Docker
# ----------------------------------------------------------------------------------------------------------------------

# install Docker
curl -sL https://get.docker.io/ | sudo sh

# add 'vagrant' user to "docker" group
sudo usermod -aG docker vagrant

# enabled when booting
sudo systemctl enable docker
sudo systemctl start  docker

sudo yum -y clean all
sudo rm -f \
  /var/log/messages\
  /var/log/lastlog\
  /var/log/auth.log\
  /var/log/syslog\
  /var/log/daemon.log\
  /var/log/docker.log\
  /home/vagrant/.bash_history\
  /var/mail/vagrant\
  || true

# disable firewalld

sudo systemctl stop firewalld
sudo systemctl disable firewalld