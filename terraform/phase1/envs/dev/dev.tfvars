# terraform/phase1/envs/dev/dev.tfvars
# "dev" environment constants

# DEV example
system_name = "rubens-system"
environment = "dev"
# use the same location used in "bootstrap-backend"
location = "eastus"

# Optional: used for later Front Door custom domain setup
# NOT used for now (maybe later I can use "ezlista.com")
#root_domain  = "example.com"

tags = {
  owner       = "rubens"
  cost_center = "dev"
}

# Networking
# A /20 VNet has 4096 IPs — plenty for:
# - 1x /21 ACA infra subnet (2048 IPs)
# - 1x /24 Postgres subnet (256 IPs)
# - Extra room for future subnets (private endpoints, other services)
# This works cleanly because 10.60.0.0/20 spans 10.60.0.0 – 10.60.15.255 and
# contains both 10.60.0.0/21 and 10.60.8.0/24.
vnet_address_space = ["10.60.0.0/20"]
# Keep ACA infra subnet at /21 to satisfy Terraform provider doc requirement
# sized for ACA infra subnet
aca_infra_subnet_prefixes = ["10.60.0.0/21"]
# Postgres delegated subnet (private access later)
# delegated subnet for private PostgreSQL later
postgres_subnet_prefixes = ["10.60.8.0/24"]

# Log Analytics
# minimum allowed is 30
log_analytics_retention_days = 30

# ACR
create_acr = true
acr_sku    = "Basic"
