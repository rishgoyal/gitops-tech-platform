resource "azurerm_resource_group" "workspace_rg" {
  name     = "rg-${var.product_name}-${var.product_id}"
  location = "West Europe"
}

module "dbx_workspace" {
  source                = "../modules/databricks"
  dbx_workspace_name    = "dbx-ws-${var.product_name}-${var.product_id}"
  access_connector_name = "dbx-ac-${var.product_name}-${var.product_id}"
  resource_group_name   = azurerm_resource_group.workspace_rg.name
}

module "function_app" {
  source              = "../modules/functions"
  resource_group_name = azurerm_resource_group.workspace_rg.name
}

module "storage" {
  source               = "../modules/storage"
  storage_account_name = "adls${replace(var.product_name, "-", "")}${var.product_id}"
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
  # subscription_id = var.ARM_SUBSCRIPTION_ID
  # client_id       = var.ARM_CLIENT_ID
  # client_secret   = var.ARM_CLIENT_SECRET
  # tenant_id       = var.ARM_TENANT_ID
  storage_use_azuread = true
  features {}
  
}

