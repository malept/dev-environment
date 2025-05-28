# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

# 1.3.0 required for salt provisioning
# 1.5.0 required for short box names
Vagrant.require_version '>= 1.5.0'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.provider "virtualbox" do |p|
    p.box = "ubuntu/jammy64"
  end

  config.vm.provider "docker" do |d|
    d.build_dir = "."
  end

  ## For masterless, mount your salt file root
  config.vm.synced_folder "salt/roots/", "/srv/salt/"
  config.vm.synced_folder "salt/formulae/", "/srv/salt-formulae/"
  config.vm.synced_folder "salt/pillars/", "/srv/pillar/"

  ## Provision with salt
  config.vm.provision :salt do |salt|
    salt.minion_config = 'salt/vagrant-minion'
    salt.run_highstate = true
  end
end
