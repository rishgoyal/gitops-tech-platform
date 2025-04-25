
resource "azurerm_storage_account" "func_storage" {
  name                     = "linfuncrgst"
  resource_group_name      = var.resource_group_name
  location                 = "West Europe"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "func_service_plan" {
  name                = "rg-service-plan"
  resource_group_name = var.resource_group_name
  location            = "West Europe"
  os_type             = "Linux"
  sku_name            = "B1"
}

# resource "azurerm_linux_function_app" "func_app" {
#   name                = "rg-linux-func-app"
#   resource_group_name = var.resource_group_name
#   location            = "West Europe"

#   storage_account_name          = azurerm_storage_account.func_storage.name
#   storage_uses_managed_identity = true
#   service_plan_id               = azurerm_service_plan.func_service_plan.id

#   identity {
#     type = "SystemAssigned"
#   }
#   site_config {}
# }

resource "azurerm_linux_function_app" "func_app" {
  for_each = toset(var.function_app_names)

  name                = each.value
  resource_group_name = var.resource_group_name
  location            = "West Europe"

  storage_account_name          = azurerm_storage_account.func_storage.name
  storage_uses_managed_identity = true
  service_plan_id               = azurerm_service_plan.func_service_plan.id

  identity {
    type = "SystemAssigned"
  }
  site_config {}
}