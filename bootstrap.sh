#!/bin/bash

# Update the system
sudo yum -y update
sudo yum -y install nano

# ----------------------------------------------------------------------------------------------------------------------
# Datawire
# ----------------------------------------------------------------------------------------------------------------------

curl -s https://packagecloud.io/install/repositories/datawire/stable/script.rpm.sh | sudo bash
sudo yum -y install datawire-directory

IP="$(/sbin/ifconfig eth0 | grep 'inet\ ' | cut -d: -f2 | awk '{ print $2}')"
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

# pull the images used
docker -D pull quay.io/datawire/bakerstreet-hello:v1
docker -D pull quay.io/datawire/bakerstreet-hello:v2

# boot what will effectively be the "client" container; the mapped_port isn't important here because we're going to
# shutdown the service.
docker run -d\
 -e mapped_port=8000\
 -e dw_directory_host=${IP}\
 --name=client\
 --add-host dockerhost:${IP}\
 quay.io/datawire/bakerstreet-hello:v1
sleep 5
docker exec client sv down watson
docker exec client sv down hello
