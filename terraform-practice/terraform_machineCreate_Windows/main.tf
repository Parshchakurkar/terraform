terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.35.0"
    }
  }
}

provider "azurerm" {
  features {
  }
  subscription_id = var.subscription #get it from az login

}

variable "subscription" {
  description = "Azure subscription ID"
  default     = ""
  sensitive   = true
  
}
module "vm" {
  source          = "./Module/VM"
  username        = "azureuser" # set your username here
  password        = "Password123!" # set your password here
}