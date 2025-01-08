resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

# Random Integer for Cosmos DB Name
resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

# Azure Cosmos DB
resource "azurerm_cosmosdb_account" "db" {
  name                       = "tfex-cosmos-db-${random_integer.ri.result}"
  location                   = azurerm_resource_group.example.location
  resource_group_name        = azurerm_resource_group.example.name
  offer_type                 = "Standard"
  kind                       = "MongoDB"
  #automatic_failover_enabled = true

  capabilities {
    name = "EnableAggregationPipeline"
  }
  capabilities {
    name = "mongoEnableDocLevelTTL"
  }
  capabilities {
    name = "MongoDBv3.4"
  }
  capabilities {
    name = "EnableMongo"
  }

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }

  geo_location {
    location          = "eastus"
    failover_priority = 1
  }
  geo_location {
    location          = "westus"
    failover_priority = 0
  }
}

# App Service Plan
resource "azurerm_app_service_plan" "example" {
  name                = var.app_service_plan_name
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

# App Service
resource "azurerm_app_service" "example" {
  name                = "example-app-service"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  app_service_plan_id = azurerm_app_service_plan.example.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }

  app_settings = {
    "CosmosDBConnectionString" = azurerm_cosmosdb_account.db.connection_strings[0]
  }
}

# Azure AI Search
resource "azurerm_search_service" "example" {
  name                = "example-resource"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku                 = "standard"
}

# Azure Storage Account
resource "azurerm_storage_account" "example" {
  name                     = "storageaccountname"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Azure Monitor
resource "azurerm_monitor_diagnostic_setting" "example" {
  name               = "example-monitor"
  target_resource_id = azurerm_app_service.example.id
  storage_account_id = azurerm_storage_account.example.id

  metric {
    category = "AllMetrics"
  }
}

# Azure OpenAI Service
# resource "azurerm_openai_service" "example_eastus" {
#   name                = "example-openai-service-eastus"
#   location            = "East US"
#   resource_group_name = azurerm_resource_group.example.name
# }

# resource "azurerm_openai_service" "example_eastus2" {
#   name                = "example-openai-service-eastus2"
#   location            = "East US 2"
#   resource_group_name = azurerm_resource_group.example.name
# }

# Content Delivery Network
resource "azurerm_cdn_profile" "example" {
  name                = "exampleCdnProfile"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "Standard_Verizon"

  tags = {
    environment = "Devlopement"
    cost_center = "MSFT"
  }
}

output "app_service_plan_id" {
  value = azurerm_app_service_plan.example.id
}