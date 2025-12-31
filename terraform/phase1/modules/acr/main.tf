# terraform/phase1/modules/acr/main.tf
# "acr" module main logic

resource "azurerm_container_registry" "this" {
  # ACR stores container images for all microservices in this system.
  #
  # We disable admin access and will rely on managed identity + AcrPull role assignment later.
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku           = var.sku
  admin_enabled = false

  tags = var.tags
}
