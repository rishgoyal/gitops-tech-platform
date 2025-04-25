output "dbx_access_connector_id" {
  value       = azurerm_databricks_access_connector.dbx_access_connector.identity[0].principal_id
  sensitive   = true
  description = "dbx_access_connector_identity"
  depends_on  = []
}
