

resource "azurerm_resource_group" "matrubhasha_rg" {
  name = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "test_vnet" {
  location = azurerm_resource_group.matrubhasha_rg.location
  name = var.vnet_name
  resource_group_name = azurerm_resource_group.matrubhasha_rg.name
  address_space = ["10.0.0.0/16"]
  depends_on = [ azurerm_resource_group.matrubhasha_rg ]
}

resource "azurerm_subnet" "test_subnenet" {
  name = var.subnet_name
  resource_group_name = azurerm_resource_group.matrubhasha_rg.name
  virtual_network_name = azurerm_virtual_network.test_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
  depends_on = [ azurerm_virtual_network.test_vnet ]
}

resource "azurerm_network_security_group" "webserver" {
  name                = "matrubhashaai_webserver"
  location            = azurerm_resource_group.matrubhasha_rg.location
  resource_group_name = azurerm_resource_group.matrubhasha_rg.name
  security_rule {
    name                       = "AllowSSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
resource "azurerm_public_ip" "pip" {
  name                = "matrubhashaai-pip"
  resource_group_name = azurerm_resource_group.matrubhasha_rg.name
  location            = azurerm_resource_group.matrubhasha_rg.location
  allocation_method   = "Static"
  depends_on          = [azurerm_resource_group.matrubhasha_rg]
}

resource "azurerm_network_interface" "test_nic" {
  name = "${var.vm_name}-nic"
  location = azurerm_resource_group.matrubhasha_rg.location
  resource_group_name = azurerm_resource_group.matrubhasha_rg.name
  ip_configuration {
    name = "internal"
    subnet_id = azurerm_subnet.test_subnenet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.pip
  }
    depends_on = [ azurerm_subnet.test_subnenet, azurerm_public_ip.pip ]
}

resource "azurerm_network_interface_security_group_association" "mamatrubhashaaisgs" {
  network_interface_id      = azurerm_network_interface.test_nic.id
  network_security_group_id = azurerm_network_security_group.webserver.id
  depends_on = [ azurerm_network_interface.test_nic, azurerm_network_security_group.webserver ]
}

resource "azurerm_linux_virtual_machine" "name" {
  location = azurerm_resource_group.matrubhasha_rg.location
  resource_group_name = azurerm_resource_group.matrubhasha_rg.name
  name = var.vm_name
  network_interface_ids = [azurerm_network_interface.test_nic]
  size = "Standard_B2ms"
  admin_username = "pnchakur"
  admin_ssh_key {
    username = "pnchakur"
    public_key = "file(\"~/.ssh/id_rsa.pub\")"
    }
    os_disk {
      caching              = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }
    source_image_reference {
        publisher = "Canonical"
        offer = "0001-com-ubuntu-server-jammy"
        sku = "22_04-lts"
        version = "latest"
    }

}