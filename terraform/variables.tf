variable "proxmox_url" {
  type = string
}

variable "proxmox_node" {
  default = "proxmox"
}

variable "vm_disk" {
  default = "local-lvm"
}

variable "vm_disk_discard" {
  default = "on"
}

variable "hostonly_network" {
  default = "vmbr0"
}

variable "vm_network" {
  default = "vmbr1"
}