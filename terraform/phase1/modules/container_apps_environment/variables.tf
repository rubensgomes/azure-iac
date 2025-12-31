# terraform/phase1/modules/container_apps_environment/variables.tf
# "container_apps_environment" module variables

variable "name" {
  type        = string
  description = "Container Apps Environment name."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group where the environment is created."
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Log Analytics workspace ID for environment logs."
}

variable "infrastructure_subnet_id" {
  type        = string
  description = "Subnet ID used for ACA environment infrastructure integration."
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to the environment."
}
