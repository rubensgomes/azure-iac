# terraform/phase1/modules/resource_group/outputs.tf
# "resource_group" module outputs

output "name" {
  description = "Resource group name."
  value       = azurerm_resource_group.this.name
}

output "id" {
  description = "Resource group ID."
  value       = azurerm_resource_group.this.id
}
