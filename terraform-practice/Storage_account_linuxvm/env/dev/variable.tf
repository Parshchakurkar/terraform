variable "subscription_id" {
  type = string
}
 
variable "location" {
	type = string
    default = "central india"
}
variable "resource_group_name" {
  type = string
  default = "matrubhasha-rg"
}

variable "storage_account_name" {
  default = "matrubhashaai"
}

variable "container_name" {
  default = "terraform"
}

variable "vnet_name" {
  default = "matrubhasha-vnet"
  type = string
}
variable "subnet_name" {
  type = string
  default = "matrubhasha-subnet"
}
variable "vm_name" {
  type = string
  default = "matrubhasha1"
}