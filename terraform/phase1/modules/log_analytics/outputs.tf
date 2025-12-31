# terraform/phase1/modules/log_analytics/outputs.tf
# "log_analytics" module outputs

output "id" {
  description = "Workspace resource ID."
  value       = azurerm_log_analytics_workspace.this.id
}

output "name" {
  description = "Workspace name."
  value       = azurerm_log_analytics_workspace.this.name
}
