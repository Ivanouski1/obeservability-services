# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.ssh.insert_key = false
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "512"]
  end

  # Application server 1
  config.vm.define "app1" do |app|
    app.vm.hostname = "app1"
    app.vm.box = "geerlingguy/centos7"
    app.vm.network :private_network, ip: "192.168.80.2"
  end


end
