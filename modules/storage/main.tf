resource "azurerm_storage_account" "storage" {
  name                      = var.storage_account_name
  resource_group_name       = var.resource_group_name
  location                  = "West Europe"
  account_tier              = "Standard"
  account_replication_type  = "GRS"
  is_hns_enabled            = true
  shared_access_key_enabled = false

  tags = {
    environment = "production"
  }
}

resource "azurerm_role_assignment" "storage_access" {
  for_each             = { for idx, val in var.role_assignments : idx => val }
  principal_id         = each.value.principal_id
  role_definition_name = "Storage Blob Data Owner"
  scope                = azurerm_storage_account.storage.id
}
