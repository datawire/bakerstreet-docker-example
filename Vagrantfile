# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = 'bento/centos-7.1'
  config.vm.box_check_update = false
  config.vbguest.auto_update = false

  config.vm.network 'forwarded_port', guest: 9000, host: 9000
  config.vm.network 'forwarded_port', guest: 9001, host: 9001
  config.vm.network 'forwarded_port', guest: 9002, host: 9002
  config.vm.network 'forwarded_port', guest: 9003, host: 9003
  config.vm.network 'forwarded_port', guest: 9004, host: 9004

  config.vm.synced_folder "scripts/", "/scripts"

  config.vm.provider 'virtualbox' do |vb|
    vb.gui = false
    vb.memory = '512'
    vb.customize ["modifyvm", :id, "--nictype1", "virtio"]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end

  config.vm.provision "shell", path: "bootstrap.sh"
  config.vm.provision "file", source: "scripts/launch_service.sh", destination: "launch_service.sh"
  config.vm.provision "shell", inline: "chmod +x launch_service.sh"
end
