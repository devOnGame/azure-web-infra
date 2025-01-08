variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure location for the resources"
  type        = string
}

variable "storage_account_name" {
  description = "The name of the storage account for Terraform state"
  type        = string
}

variable "container_name" {
  description = "The name of the blob container for Terraform state"
  type        = string
}

variable "app_service_plan_name" {
  description = "The name of the App Service Plan"
  type        = string
}

variable "cosmosdb_account_name" {
  description = "The name of the Cosmos DB account"
  type        = string
}