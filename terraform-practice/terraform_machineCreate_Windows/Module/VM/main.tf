resource "azurerm_resource_group" "rg-vm" {
  name     = "terraform-VMCreate"
  location = "Central India"
}


resource "azurerm_virtual_network" "network-vm" {
  name                = "terraform-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg-vm.location
  resource_group_name = azurerm_resource_group.rg-vm.name
}

resource "azurerm_subnet" "subnet-vm" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.rg-vm.name
  virtual_network_name = azurerm_virtual_network.network-vm.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "netinterface-vm" {
  name                = "vm_nic"
  location            = azurerm_resource_group.rg-vm.location
  resource_group_name = azurerm_resource_group.rg-vm.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet-vm.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vmcreate" {
  name                = "TestVM2"
  resource_group_name = azurerm_resource_group.rg-vm.name
  location            = azurerm_resource_group.rg-vm.location
  size                = "Standard_B2ms"
  admin_username      = var.username
  admin_password      = var.password
  network_interface_ids = [
    azurerm_network_interface.netinterface-vm.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}