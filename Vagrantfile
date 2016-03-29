Vagrant.configure("2") do |config|
  config.vm.network "public_network", type: "dhcp", bridge: "en4: Thunderbolt Ethernet"
  config.vm.box = "centos/7"
  config.vm.provider "virtualbox" do |v|
    v.memory = 4096
    v.cpus = 4
  end
  config.vm.provision "shell", path: "provision-all.sh"

  config.vm.define "node1" do |node1|
    node1.vm.hostname = "node1"
  end

  config.vm.define "node2" do |node2|
    node2.vm.hostname = "node2"
  end

  config.vm.define "master", primary: true do |master|
    master.vm.hostname = "master"
    master.vm.provision "shell", path: "provision-master.sh"
  end

end
