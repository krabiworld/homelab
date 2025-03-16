packer {
  required_plugins {
    ansible = {
      version = ">= 1.1.3"
      source  = "github.com/hashicorp/ansible"
    }

    vagrant = {
      version = ">= 1.1.5"
      source  = "github.com/hashicorp/vagrant"
    }
  }
}

source "vagrant" "box" {
  communicator = "ssh"
  source_path  = "net9/ubuntu-24.04-arm64"
  provider     = "virtualbox"
  skip_add     = true
}

build {
  sources = ["vagrant.box"]

  provisioner "ansible" {
    playbook_file    = "../ansible/playbook.yml"
    ansible_env_vars = ["ANSIBLE_CONFIG=../ansible/ansible.cfg"]
  }
}
