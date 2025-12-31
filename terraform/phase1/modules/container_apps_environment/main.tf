# terraform/phase1/modules/container_apps_environment/main.tf
# "container_apps_environment" module main logic

resource "azurerm_container_app_environment" "this" {
  # This is an EXTERNAL Container Apps Environment.
  # We intentionally do NOT set internal_load_balancer_enabled=true.
  # External environment allows container apps to expose external ingress later.
  #
  # VNet integration is enabled via infrastructure_subnet_id so container apps can reach
  # private resources later (e.g., PostgreSQL Flexible Server private access).
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  logs_destination           = "log-analytics"
  log_analytics_workspace_id = var.log_analytics_workspace_id

  infrastructure_subnet_id = var.infrastructure_subnet_id

  tags = var.tags
}
