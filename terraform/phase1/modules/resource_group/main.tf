# terraform/phase1/modules/resource_group/main.tf
# "resource_group" module main logic

resource "azurerm_resource_group" "this" {
  # Resource Group is the logical container for all system resources.
  # Keeping Phase 1 resources in one RG simplifies auditing and cleanup.
  name     = var.name
  location = var.location
  tags     = var.tags
}
