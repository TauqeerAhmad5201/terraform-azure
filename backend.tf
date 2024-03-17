terraform {
  backend "azurerm" {
    resource_group_name  = "backend-terra-test"
    storage_account_name = "storagetauqeer007"
    container_name       = "tfstate"
    key                  = "app-service.tfstate"
  }
}