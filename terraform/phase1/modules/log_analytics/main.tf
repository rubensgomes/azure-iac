# terraform/phase1/modules/log_analytics/main.tf
# "log_analytics" module main logic

resource "azurerm_log_analytics_workspace" "this" {
  # ACA environments commonly use Log Analytics for logs/diagnostics.
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku               = "PerGB2018"
  retention_in_days = var.retention_in_days

  tags = var.tags
}
