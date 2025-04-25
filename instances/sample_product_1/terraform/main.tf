resource "azurerm_resource_group" "workspace_rg" {
  name     = "rg-${var.product_name}-${var.product_id}"
  location = "West Europe"
}


module "function_app" {
  source              = "../../../tf_modules/functions"
  resource_group_name = azurerm_resource_group.workspace_rg.name
  function_app_names  = ["ingest001sales", "transform001sales", "export001sales"]
}

module "storage" {
  source               = "../../../tf_modules/storage"
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
  storage_use_azuread = true
  features {}
  
}

