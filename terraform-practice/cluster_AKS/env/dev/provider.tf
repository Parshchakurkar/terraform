terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.55.0"
    }
  }
  backend "azurerm" {
    key                  = "env/dev/terraform.tfstate"
    resource_group_name  = "aks_cluster"
    storage_account_name = "aksstorage1235"
    container_name       = "akscluster"
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  features {
  }
}
