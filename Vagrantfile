# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.ssh.insert_key = false
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "512"]
  end

  # ldap-server 
  config.vm.define "ldap_server" do |ldap|
    ldap.vm.hostname = "vm1"
    ldap.vm.box = "geerlingguy/centos7"
    ldap.vm.network :private_network, ip: "192.168.80.10"
    ldap.vm.provision "file", source: "doc/files", destination: "$HOME/Documents/lib/LDAP/ldap/doc/files"
    ldap.vm.provision "shell", path: "doc/server.sh", privileged: false	
  end

  # ldap-client
  config.vm.define "ldap_client" do |ldap|
    ldap.vm.hostname = "vm2"
    ldap.vm.box = "geerlingguy/centos7"
    ldap.vm.network :private_network, ip: "192.168.80.20"
    ldap.vm.provision "shell", path: "doc/client.sh", privileged: false
  end

end