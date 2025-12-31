# terraform/phase1/modules/networking/variables.tf
# "networking" module variables

variable "name_prefix" {
  type        = string
  description = "Prefix used for naming VNet/subnets (typically <system_name>-<environment>)."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group where networking resources are created."
}

variable "vnet_address_space" {
  type        = list(string)
  description = "VNet CIDR(s)."
}

variable "aca_infra_subnet_prefixes" {
  type        = list(string)
  description = "CIDR(s) for the Container Apps Environment infrastructure subnet."
}

variable "postgres_subnet_prefixes" {
  type        = list(string)
  description = "CIDR(s) for the delegated PostgreSQL subnet."
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to networking resources."
}
