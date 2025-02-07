variable "USERNAME" {
  type = string
}

variable "PASSWORD" {
  type = string
}

variable "PROXMOX" {
  type = string
}

provider "proxmox" {
    pm_api_url   = "https://${var.PROXMOX}:8006/api2/json"
    pm_user      = var.USERNAME
    pm_password  = var.PASSWORD
    pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "my_vm" {
    name       = "zeek"
    target_node = "pve"
    clone      = "Ubuntu2504"
    storage    = "local-lvm"
    cores      = 1
    memory     = 2048
}