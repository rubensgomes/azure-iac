# envs/dev/main.tf
# envs/dev module root

resource "azurerm_resource_group" "env" {
  name     = var.rg_name
  location = var.location
  tags     = merge(var.tags, { env = var.environment })
}

module "app" {
  source = "../../modules/app"

  environment               = var.environment
  location                  = var.location
  resource_group_name       = azurerm_resource_group.env.name
  app_storage_account_prefix = var.app_storage_account_prefix
  tags                      = merge(var.tags, { env = var.environment })
}


