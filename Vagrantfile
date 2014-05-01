# -*- mode: ruby -*-
# vi: set ft=ruby :

nodes = [
  {:hostname => 'node1', :ip => '172.16.32.10', :box => 'trusty64'},
  {:hostname => 'node2', :ip => '172.16.32.11', :box => 'trusty64'},
  {:hostname => 'node3', :ip => '172.16.32.12', :box => 'trusty64'},
  ]

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  nodes.each do |node|
    config.vm.define node[:hostname] do |node_config|
      node_config.vm.box = node[:box]
      node_config.vm.box_url = 'http://files.vagrantup.com/' + node_config.vm.box + '.box'
      node_config.vm.hostname = node[:hostname] + '.' + 'example.org'
      node_config.vm.network :private_network, ip: node[:ip]

      memory = node[:ram] ? node[:ram] : 256;
      node_config.vm.provider :virtualbox do |vb|
        vb.customize [
          'modifyvm', :id,
          '--name', node[:hostname],
          '--memory', memory.to_s
        ]
      end
      config.vm.provision "shell", path: "provision/deps.sh"
      config.vm.provision "shell", path: "provision/consul.sh"
      config.vm.provision "shell" do |s|
        s.path = "provision/consul-start.sh"
        if node[:hostname] == 'node1'
          s.args = '-bootstrap'
        end
      end
    end
  end
end
