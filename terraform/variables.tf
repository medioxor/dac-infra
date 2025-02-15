variable "proxmox_url" {
  type = string
}

variable "proxmox_node" {
  default = "proxmox"
}

variable "vm_disk" {
  default = "local-lvm"
}

variable "proxmox_lan" {
  default = "vmbr0"
}

variable "vm_network" {
  default = "vmbr1"
}