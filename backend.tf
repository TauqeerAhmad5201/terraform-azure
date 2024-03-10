terraform {
  backend "azurerm" {
    resource_group_name  = "my-ubuntu-rg"
    storage_account_name = "storage"
    container_name       = "TFbackend"
    key                  = "prod.terraform.tfstate"
  }
}