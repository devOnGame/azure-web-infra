terraform {
  backend "azurerm" {
    resource_group_name  = "eon1"
    storage_account_name = "akshcldevops"
    container_name       = "aks-dev-state"
    key                  = "dev.terraform.tfstate"
  }
}