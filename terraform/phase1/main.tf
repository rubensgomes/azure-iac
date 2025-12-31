# terraform/phase1/main.tf
# "phase1" main root logic wiring

############################
# Locals: naming and tags
############################

locals {
  # Shared prefix for system-scoped resources
  system_prefix = "${var.system_name}-${var.environment}"

  # Optional future public API domain (for Azure Front Door custom domain)
  public_api_domain = var.root_domain != null ? "api.${var.system_name}.${var.root_domain}" : null

  tags = merge(
    {
      system      = var.system_name
      environment = var.environment
      managed_by  = "terraform"
      phase       = "phase1"
    },
    var.tags
  )
}

############################
# Module: Resource Group
############################
module "rg" {
  source   = "./modules/resource_group"
  name     = "${local.system_prefix}-rg"
  location = var.location
  tags     = local.tags
}

############################
# Module: Networking
############################
module "networking" {
  source              = "./modules/networking"
  name_prefix         = local.system_prefix
  location            = var.location
  resource_group_name = module.rg.name

  vnet_address_space        = var.vnet_address_space
  aca_infra_subnet_prefixes = var.aca_infra_subnet_prefixes
  postgres_subnet_prefixes  = var.postgres_subnet_prefixes

  tags = local.tags
}

############################
# Module: Log Analytics
############################
module "log_analytics" {
  source              = "./modules/log_analytics"
  name                = "${local.system_prefix}-law"
  location            = var.location
  resource_group_name = module.rg.name
  retention_in_days   = var.log_analytics_retention_days
  tags                = local.tags
}

############################
# Module: Container Apps Environment (EXTERNAL)
############################
module "cae" {
  source                     = "./modules/container_apps_environment"
  name                       = "${local.system_prefix}-cae"
  location                   = var.location
  resource_group_name        = module.rg.name
  log_analytics_workspace_id = module.log_analytics.id

  # VNet integration so Container Apps can reach private resources later (e.g., private PostgreSQL).
  infrastructure_subnet_id = module.networking.aca_infra_subnet_id

  tags = local.tags
}

############################
# Module: ACR (optional)
############################
module "acr" {
  source = "./modules/acr"
  count  = var.create_acr ? 1 : 0

  # ACR name must be alphanumeric only; remove hyphens from the system prefix.
  # Also must be globally unique - you may need to add a suffix later (random_string) if collisions occur.
  name                = replace("${local.system_prefix}acr", "-", "")
  location            = var.location
  resource_group_name = module.rg.name
  sku                 = var.acr_sku
  tags                = local.tags
}
