# terraform/phase1/outputs.tf
# "phase1" outputs shared by all modules

output "system_name" {
  description = "System identifier used for resource naming and public DNS."
  value       = var.system_name
}

output "environment" {
  description = "Environment (dev/qa/prod)."
  value       = var.environment
}

output "public_api_domain" {
  description = "If root_domain was provided, this is api.<system_name>.<root_domain>."
  value       = local.public_api_domain
}

output "resource_group_name" {
  description = "Resource group for the system/environment."
  value       = module.rg.name
}

output "vnet_id" {
  description = "VNet ID (used later for private endpoints and private PostgreSQL DNS linking)."
  value       = module.networking.vnet_id
}

output "aca_infra_subnet_id" {
  description = "Subnet used by the ACA Environment infrastructure_subnet_id."
  value       = module.networking.aca_infra_subnet_id
}

output "postgres_subnet_id" {
  description = "Delegated subnet for PostgreSQL Flexible Server private access (Phase 3)."
  value       = module.networking.postgres_subnet_id
}

output "log_analytics_workspace_id" {
  description = "Log Analytics workspace used by ACA Environment."
  value       = module.log_analytics.id
}

output "container_app_environment_id" {
  description = "ACA Environment ID (used later when creating container apps)."
  value       = module.cae.id
}

output "acr_login_server" {
  description = "ACR login server (null if create_acr=false)."
  value       = var.create_acr ? module.acr[0].login_server : null
}
