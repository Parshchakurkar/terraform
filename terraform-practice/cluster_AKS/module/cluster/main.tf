data "azurerm_resource_group" "aks_rg" {
  name = "aks_cluster"
}

resource "azurerm_virtual_network" "aks_vnet" {
  name                = "aks_vnet"
  location            = data.azurerm_resource_group.aks_rg.location
  resource_group_name = data.azurerm_resource_group.aks_rg.name
  address_space       = ["10.0.0.0/16"]

  subnet {
    name           = "aks_subnet"
    address_prefixes = ["10.0.0.0/24"]
  }

  tags = {
    Environment = var.environmet
    Terraform   = "true"
  }
}

resource "azurerm_kubernetes_cluster" "name" {
    name                = "aks-${var.environmet}-cluster"
    location            = data.azurerm_resource_group.aks_rg.location
    resource_group_name = data.azurerm_resource_group.aks_rg.name
    dns_prefix          = "aks${var.environmet}dns"
    
    default_node_pool {
        name       = "default"
        node_count = 2
        vm_size    = "standard_D2ds_v6"
    }
    
    identity {
        type = "SystemAssigned"
    }
    
    tags = {
        Environment = var.environmet
        Terraform = "true"
    }
}