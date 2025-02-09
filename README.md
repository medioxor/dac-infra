# What is this?
This is my own implementation of DetectionLab (https://github.com/clong/DetectionLab) with a focus being on Proxmox as the back-end, so big thanks to @clong for the reference implementation.

# Set up
The following assumptions are made:
- The provisioning host and the proxmox device are on the same LAN
- The interface associated with the LAN on the proxmox device is called `enp7s0` and the IP of the proxmox device is `192.168.0.55`

## Proxmox
- Add the following to `/etc/network/interfaces` and execute `ifreload -a` to apply the new configuration once saved
    ```
    auto lo
    iface lo inet loopback

    auto enp7s0
    iface enp7s0 inet manual

    auto vmbr0
    iface vmbr0 inet static
        address 192.168.0.55/24
        gateway 192.168.0.1
        bridge_ports enp7s0
        bridge_stp off
        bridge_fd 0

    auto vmbr1
    iface vmbr1 inet manual
        bridge-ports none
        bridge-stp off
        bridge-fd 0

    source /etc/network/interfaces.d/*
    ```
- Create Packer account
    ```
    pveum useradd infra_as_code@pve
    pveum passwd infra_as_code@pve
    pveum roleadd Packer -privs "VM.Config.Disk VM.Config.CPU VM.Config.Memory Datastore.AllocateTemplate Datastore.Audit Datastore.AllocateSpace Sys.Modify VM.Config.Options VM.Allocate VM.Audit VM.Console VM.Config.CDROM VM.Config.Cloudinit VM.Config.Network VM.PowerMgmt VM.Config.HWType VM.Monitor SDN.Use"
    pveum acl modify / -user 'infra_as_code@pve' -role Packer
    pveum acl modify / -user 'infra_as_code@pve' -role Administrator
    ```

## Provisioning host (Debian)
- Install Terraform, Packer, and Ansible
    ```
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
    sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
    sudo apt update
    sudo apt install -y terraform packer python3-pip sshpass genisoimage
    packer plugins install github.com/hashicorp/proxmox
    pip3 install ansible pywinrm --user
    ```
- Set the following environment variables in the file `.env` within the root of this repository:
    ```
    # username goes here
    PM_USER=infra_as_code@pve
    # password of the deployment account goes here
    PM_PASS=asdfASDF1!
    # the ip address of the proxmox device goes here
    PM_HOST=192.168.0.55
    ```

# Deployment
- Firstly build and push the root images to Proxmox using Packer:
    ```
    ./build.sh
    ```
- Once built, deploy the infrastructure using Terraform and kick off configuration using Ansible:
    ```
    ./deploy.sh
    ```
- To destroy the infrastructure use the following:
    ```
    ./destory.sh
    ```