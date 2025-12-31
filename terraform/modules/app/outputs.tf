# modules/app/outputs.tf
# modules/app outputs

output "storage_account_name" {
  value = azurerm_storage_account.app.name
}

