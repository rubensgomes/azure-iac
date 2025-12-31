# terraform/phase1/modules/container_apps_environment/outputs.tf
# "container_apps_environment" module outputs

output "id" {
  description = "Container Apps Environment ID."
  value       = azurerm_container_app_environment.this.id
}

output "name" {
  description = "Container Apps Environment name."
  value       = azurerm_container_app_environment.this.name
}

output "default_domain" {
  description = "Default domain suffix for apps in this environment (useful later for internal DNS patterns)."
  value       = azurerm_container_app_environment.this.default_domain
}

