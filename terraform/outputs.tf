output "router" {
  description = "The IP address of the deployed router VM"
  value       = proxmox_vm_qemu.router.default_ipv4_address
}

output "dc" {
  description = "The IP address of the Domain Controller"
  value       = proxmox_vm_qemu.dc.default_ipv4_address
}

output "workstation1" {
  description = "The IP address of workstation1"
  value       = proxmox_vm_qemu.workstation1.default_ipv4_address
}