resource "azurerm_resource_group" "matrubhasha_rg" {
  name = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "matrubhasha_storage_account" {
  name = var.storage_account_name
  resource_group_name = azurerm_resource_group.matrubhasha_rg.name
  location = azurerm_resource_group.matrubhasha_rg.location
  account_tier = "Standard"
  account_replication_type = "LRS"
  
}

resource "azurerm_storage_container" "matrubhasha_container" {
  name = var.container_name
  storage_account_id = azurerm_storage_account.matrubhasha_storage_account.id
  container_access_type = "private"
}

output "containername" {
  value = azurerm_storage_container.matrubhasha_container.name
}