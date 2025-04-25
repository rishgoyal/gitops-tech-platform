output "function_app_identities" {
  value = { for name, app in azurerm_linux_function_app.func_app : name => app.identity[0].principal_id }
}