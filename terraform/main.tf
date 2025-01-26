resource "azurerm_resource_group" "workspace_rg" {
  name     = "workspace_rg_01"
  location = "West Europe"
}

module "dbx_workspace" {
  source                = "../modules/databricks"
  dbx_workspace_name    = "pilot-dbx-rg-ws-01"
  access_connector_name = "pilot-dbx-rg-ac-01"
  resource_group_name   = azurerm_resource_group.workspace_rg.name
}

module "function_app" {
  source              = "../modules/functions"
  resource_group_name = azurerm_resource_group.workspace_rg.name
}

module "storage" {
  source               = "../modules/storage"
  storage_account_name = "pilotstrg01"
  resource_group_name  = azurerm_resource_group.workspace_rg.name
  role_assignments = [
    {
      principal_id = module.dbx_workspace.dbx_access_connector_id
    },
    {
      principal_id = module.function_app.function_app_identity
    },
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
  subscription_id     = var.subscription_id
  storage_use_azuread = true
  features {}
}

