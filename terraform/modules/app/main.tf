# modules/app/main.tf
# modules/app reusable logic

# Simple example resource so you can validate end-to-end.
# You can replace this module with your real infra modules.

locals {
  # Example: stappdev -> must be <= 24 chars and globally unique in real life,
  # so you may want to add a random suffix in production modules.
  storage_account_name = substr(lower("${var.app_storage_account_prefix}${var.environment}"), 0, 24)
}

resource "azurerm_storage_account" "app" {
  name                     = local.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false

  tags = var.tags
}

