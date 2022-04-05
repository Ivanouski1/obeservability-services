# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.ssh.insert_key = false
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "512"]
  end

  # ZABBIX server 
  config.vm.define "zabbix_server" do |zabbix|
    zabbix.vm.hostname = "server"
    zabbix.vm.box = "geerlingguy/centos7"
    zabbix.vm.network :private_network, ip: "192.168.80.10"
    zabbix.vm.provision "file", source: "docs/conf", destination: "$HOME/conf"
    zabbix.vm.provision "shell", path: "docs/zabbix_server.sh", privileged: false	
  end

  # ZABBIX client
  config.vm.define "zabbix_agent" do |zabbix|
    zabbix.vm.hostname = "agent"
    zabbix.vm.box = "geerlingguy/centos7"
    zabbix.vm.network :private_network, ip: "192.168.80.20"
    zabbix.vm.provision "shell", path: "docs/zabbix_agent.sh", privileged: false
  end

end