output "vnet01_id" {
  value       = azurerm_virtual_network.vnet01.id
  description = "The ID of the virtual network VNET01."
}

output "vnet02_id" {
  value       = azurerm_virtual_network.vnet02.id
  description = "The ID of the virtual network VNET02."
}

output "machine01_public_ip" {
  value       = azurerm_public_ip.machine01_ip.ip_address
  description = "The public IP address of virtual machine Machine01."
}

output "machine02_public_ip" {
  value       = azurerm_public_ip.machine02_ip.ip_address
  description = "The public IP address of virtual machine Machine02."
}

output "machine01_nic_id" {
  value       = azurerm_network_interface.machine01_nic.id
  description = "The ID of the network interface for Machine01."
}

output "machine02_nic_id" {
  value       = azurerm_network_interface.machine02_nic.id
  description = "The ID of the network interface for Machine02."
}

output "machine01_vm_id" {
  value       = azurerm_virtual_machine.machine01.id
  description = "The ID of virtual machine Machine01."
}

output "machine02_vm_id" {
  value       = azurerm_virtual_machine.machine02.id
  description = "The ID of virtual machine Machine02."
}

output "machine01_disk_id" {
  value       = azurerm_managed_disk.machine01_disk1.id
  description = "The ID of the managed disk attached to Machine01."
}

output "machine02_disk_id" {
  value       = azurerm_managed_disk.machine02_disk1.id
  description = "The ID of the managed disk attached to Machine02."
}
