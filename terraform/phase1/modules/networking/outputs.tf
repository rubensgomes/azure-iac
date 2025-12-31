# terraform/phase1/modules/networking/outputs.tf
# "networking" module outputs

output "vnet_id" {
  description = "VNet ID."
  value       = azurerm_virtual_network.this.id
}

output "vnet_name" {
  description = "VNet name."
  value       = azurerm_virtual_network.this.name
}

output "aca_infra_subnet_id" {
  description = "Subnet ID for ACA environment infrastructure."
  value       = azurerm_subnet.aca_infra.id
}

output "postgres_subnet_id" {
  description = "Delegated subnet ID for PostgreSQL private access."
  value       = azurerm_subnet.postgres.id
}
