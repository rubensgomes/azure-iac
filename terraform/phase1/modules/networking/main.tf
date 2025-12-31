# terraform/phase1/modules/networking/main.tf
# "networking" module main logic

resource "azurerm_virtual_network" "this" {
  name                = "${var.name_prefix}-vnet"
  location            = var.location
  resource_group_name = var.resource_group_name

  address_space = var.vnet_address_space
  tags          = var.tags
}

resource "azurerm_subnet" "aca_infra" {
  # Dedicated subnet for the ACA environment infrastructure integration.
  # This subnet should not be used by other services.
  name                 = "${var.name_prefix}-snet-aca-infra"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name

  address_prefixes = var.aca_infra_subnet_prefixes
}

resource "azurerm_subnet" "postgres" {
  # Dedicated subnet for PostgreSQL Flexible Server private access (VNet Integration).
  # The subnet must be delegated to Microsoft.DBforPostgreSQL/flexibleServers so that
  # azurerm_postgresql_flexible_server can be deployed privately later.
  name                 = "${var.name_prefix}-snet-postgres"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name

  address_prefixes = var.postgres_subnet_prefixes

  delegation {
    name = "postgres-flexible-server-delegation"

    service_delegation {
      name    = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}
