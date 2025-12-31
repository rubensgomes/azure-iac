# terraform/phase1/modules/acr/variables.tf
# "acr" module variables

variable "name" {
  type        = string
  description = "Azure Container Registry name (alphanumeric only, globally unique)."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group where ACR is created."
}

variable "sku" {
  type        = string
  description = "ACR SKU: Basic | Standard | Premium."
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to ACR."
}
