# krabi homelab

## How to run
```shell
# Install Ansible and required libraries in virtual environment
cd ansible
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

# Build Vagrant box
cd ../packer
packer init .
packer build .
vagrant box add --provider=virtualbox --name=homelab/ubuntu output-box/package.box

# Start virtual machine
cd ../vagrant
vagrant up
```
