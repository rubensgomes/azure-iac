# bootstrap-backend/outputs.tf
# "bootstrap-backend" module outputs

output "backend_resource_group_name" {
  value       = azurerm_resource_group.tfstate.name
  description = "Backend RG name."
}

output "storage_account_id" {
  value       = azurerm_storage_account.tfstate.name
  description = "Storage account id for Terraform state."
}

output "container_name" {
  value       = azurerm_storage_container.tfstate.name
  description = "Container name for Terraform state."
}


