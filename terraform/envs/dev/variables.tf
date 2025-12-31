# envs/dev/variables.tf
# envs/dev module variables

variable "environment" {
  type        = string
  description = "Environment name (dev/qa/stage/prod)."
}

variable "location" {
  type        = string
  description = "Azure region for resources."
}

variable "rg_name" {
  type        = string
  description = "Environment resource group name."
}

variable "tags" {
  type        = map(string)
  description = "Common tags applied to resources."
  default     = {}
}

# Example app settings (purely illustrative)
variable "app_storage_account_prefix" {
  type        = string
  description = "Prefix for an app storage account (lowercase/numbers), will be combined with env."
  default     = "stapp"
}

