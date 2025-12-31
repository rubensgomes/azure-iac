# terraform/phase1/variables.tf
# "phase1" variables shared by all modules

############################
# Core system inputs
############################
# system is the unit of shared infra and can represent a department,
# company or platform.
variable "system_name" {
  type        = string
  description = <<EOT
System identifier used for shared Azure resources AND public DNS subdomain.
Examples: "payments", "risk", "rubens", "marketing-platform".
This system will host multiple microservices in the same ACA environment.
EOT

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system_name))
    error_message = "system_name must be lowercase and contain only letters, numbers, and hyphens (a-z, 0-9, -)."
  }
}

variable "environment" {
  type        = string
  description = "Environment name (e.g., dev, qa, prod)."
}

variable "location" {
  type        = string
  description = "Azure region for all resources in Phase 1 (e.g., eastus)."
}

variable "root_domain" {
  type        = string
  default     = null
  description = <<EOT
Optional public DNS root domain (e.g., ezlista.com).
If provided, Phase 1 outputs public_api_domain as:
  api.<system_name>.<root_domain>
This is used later when creating Azure Front Door custom domains.
EOT
}

############################
# Common tags
############################

variable "tags" {
  type        = map(string)
  description = "Tags applied to all resources."
  default     = {}
}

############################
# Networking inputs
############################

variable "vnet_address_space" {
  type        = list(string)
  description = "VNet CIDR(s). Use /16 for room to grow (private endpoints, more subnets later)."
  default     = ["10.60.0.0/16"]
}

variable "aca_infra_subnet_prefixes" {
  type        = list(string)
  description = <<EOT
Subnet CIDR(s) for the Container Apps Environment infrastructure subnet.

NOTE: When using azurerm_container_app_environment.infrastructure_subnet_id,
provider docs indicate the subnet must be large enough (commonly /21 or larger).
Plan CIDR accordingly.
EOT
  default = ["10.60.0.0/21"]
}

variable "postgres_subnet_prefixes" {
  type        = list(string)
  description = <<EOT
Subnet CIDR(s) for PostgreSQL Flexible Server private access (VNet Integration).

Phase 1 delegates this subnet to:
  Microsoft.DBforPostgreSQL/flexibleServers
so Phase 3 can create PostgreSQL with public access disabled.
EOT
  default = ["10.60.8.0/24"]
}

############################
# Observability inputs
############################

variable "log_analytics_retention_days" {
  type        = number
  description = "Log Analytics retention in days."
  default     = 30
}

############################
# Optional: Azure Container Registry
############################

variable "create_acr" {
  type        = bool
  description = "If true, create Azure Container Registry in Phase 1."
  default     = true
}

variable "acr_sku" {
  type        = string
  description = "ACR SKU: Basic | Standard | Premium."
  default     = "Standard"
}

