output "vmname" {
  value = "azurerm_windows_virtual_machine.vmcreate.name"
}

output "location" {
  value = "azurerm_resource_group.rg-vm.location"
}
output "ip" {
  value = "azurerm_network_interface.netinterface-vm.ip_configuration[0].private_ip_address"
  
}