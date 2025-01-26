output "function_app_identity" {
  value = azurerm_linux_function_app.func_app.identity[0].principal_id
}
