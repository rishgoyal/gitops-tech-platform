

resource "azurerm_databricks_workspace" "dbx_workspace" {
  name                = var.dbx_workspace_name
  resource_group_name = var.resource_group_name
  location            = "West Europe"
  sku                 = "standard"

  tags = {
    Environment = "Production"
  }
}

resource "azurerm_databricks_access_connector" "dbx_access_connector" {
  name                = var.access_connector_name
  resource_group_name = var.resource_group_name
  location            = "West Europe"

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}