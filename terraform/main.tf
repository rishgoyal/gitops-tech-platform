resource "azurerm_resource_group" "workspace_rg" {
  name     = "rg-${var.product_name}-${var.product_id}"
  location = "West Europe"
}


module "function_app" {
  source              = "../modules/functions"
  resource_group_name = azurerm_resource_group.workspace_rg.name
  function_app_names  = ["ingest001sales", "transform001sales"]  # Pass the list
}

module "storage" {
  source               = "../modules/storage"
  storage_account_name = "adls${replace(var.product_name, "-", "")}${var.product_id}"
  resource_group_name  = azurerm_resource_group.workspace_rg.name
  role_assignments = [
    for principal_id in values(module.function_app.function_app_identities) : {
      principal_id = principal_id
    }
  ]
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.16.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  # subscription_id = var.ARM_SUBSCRIPTION_ID
  # client_id       = var.ARM_CLIENT_ID
  # client_secret   = var.ARM_CLIENT_SECRET
  # tenant_id       = var.ARM_TENANT_ID
  storage_use_azuread = true
  features {}
  
}

