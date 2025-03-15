# This Vagranfile uses box for Macs with Apple Chips

Vagrant.configure("2") do |c|
    c.vm.box = "net9/ubuntu-24.04-arm64"
    c.vm.synced_folder ".", "/vagrant", disabled: true

    c.vm.provider "virtualbox" do |v|
        v.memory = 1024
        v.cpus = 2
        v.linked_clone = true
    end

    c.vm.provision "ansible" do |a|
        a.playbook = "ansible/playbook.yml"
        a.config_file = "ansible/ansible.cfg"
        a.compatibility_mode = "2.0"
    end
end
