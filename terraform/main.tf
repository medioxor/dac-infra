provider "proxmox" {
  pm_api_url = var.proxmox_url
  pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "router" {
  name = "router"
  target_node = var.proxmox_node
  clone = "Ubuntu2504"
  full_clone = false
  desc = "router"
  cores = "2"
  sockets = "1"
  cpu_type = "host"
  memory = "2048"
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"
  agent = 1
  skip_ipv6 = true
  onboot = false

  disk {
    slot = "scsi0"
    size = "64G"
    type = "disk"
    storage = var.vm_disk
    cache = "writeback"
    format = "raw"
    discard = true
  }

  network {
    id = 0
    model = "virtio"
    bridge = var.hostonly_network
    macaddr = "00:50:56:a3:b1:c2"
    firewall = false
  }

  network {
    id = 1
    model = "virtio"
    bridge = var.vm_network
    macaddr = "00:50:56:a3:b1:c4"
    firewall = false
  }

    connection {
      host = self.ssh_host
      type = "ssh"
      user = "deploy"
      password = "deploy"
    }

    provisioner "remote-exec" {
    inline = [
      "sudo ifconfig eth0 up && echo 'eth0 up' || echo 'unable to bring eth0 interface up",
      "sudo ifconfig eth1 up && echo 'eth1 up' || echo 'unable to bring eth1 interface up"
    ]
  }
}