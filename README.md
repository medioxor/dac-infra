

# Set up

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
    iface vmbr1 inet static
        address 10.10.20.1
        netmask  255.255.255.0
        bridge_ports none
        bridge_stp off
        bridge_fd 0

        post-up echo 1 > /proc/sys/net/ipv4/ip_forward
        post-up iptables -t nat -A POSTROUTING -s 10.10.20.0/24 -o vmbr0 -j MASQUERADE
        post-down iptables -t nat -D POSTROUTING -s 10.10.20.0/24 -o vmbr0 -j MASQUERADE

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
    sudo apt install -y terraform packer python3-pip sshpass
    packer plugins install github.com/hashicorp/proxmox
    pip3 install ansible pywinrm --user
    ```