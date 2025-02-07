output "router" {
  description = "The IP address of the deployed router VM"
  value       = proxmox_vm_qemu.router.ssh_host
}