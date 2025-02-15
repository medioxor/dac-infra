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
    bridge = var.proxmox_lan
    macaddr = "00:50:56:a3:b1:c0"
    firewall = false
  }

  network {
    id = 1
    model = "virtio"
    bridge = var.vm_network
    macaddr = "00:50:56:a3:b1:c1"
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

resource "proxmox_vm_qemu" "dc" {
  name = "dc"
  target_node = var.proxmox_node
  clone = "WindowsServer2025"
  full_clone = false
  desc = "dc"
  cores = "2"
  sockets = "1"
  memory = "4096"
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"
  agent = 1
  onboot = false
  cpu_type = "x86-64-v2-AES"
  skip_ipv6 = true

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
    bridge = var.proxmox_lan
    macaddr = "00:50:56:a3:b1:c2"
    firewall = false
  }

  network {
    id = 1
    model = "virtio"
    bridge = var.vm_network
    macaddr = "00:50:56:a3:b1:c3"
    firewall = false
  }
}

resource "proxmox_vm_qemu" "endpoint1" {
  name = "endpoint1"
  target_node = var.proxmox_node
  clone = "Windows11"
  full_clone = false
  desc = "endpoint1"
  cores = "2"
  sockets = "1"
  memory = "4096"
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"
  agent = 1
  onboot = false
  cpu_type = "x86-64-v2-AES"
  skip_ipv6 = true

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
    bridge = var.proxmox_lan
    macaddr = "00:50:56:a3:b1:c4"
    firewall = false
  }

  network {
    id = 1
    model = "virtio"
    bridge = var.vm_network
    macaddr = "00:50:56:a3:b1:c5"
    firewall = false
  }
}