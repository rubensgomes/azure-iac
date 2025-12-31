# bootstrap-backend/variables.tf
# "bootstrap-backend" module variables

variable "location" {
  type        = string
  description = "Azure region for the backend resources."
  default     = "eastus"
}

variable "backend_resource_group_name" {
  type        = string
  description = "Resource group that holds the Terraform remote state backend."
  default     = "rg-tfstate"
}

variable "storage_account_id" {
  type        = string
  description = "Deterministic storage account id for Terraform state. Must be globally unique, lowercase alphanumeric."

  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.storage_account_id))
    error_message = "storage_account_id must be 3-24 chars, lowercase letters and digits only."
  }
}

variable "container_name" {
  type        = string
  description = "Blob container name for Terraform state."
  default     = "tfstate"
}

variable "replication_type" {
  type        = string
  description = "Storage replication type (LRS/GRS/RAGRS/etc.)."
  default     = "LRS"
}

variable "soft_delete_retention_days" {
  type        = number
  description = "Retention days for blob/container soft delete."
  default     = 7
}

variable "enable_rg_lock" {
  type        = bool
  description = "If true, applies a CanNotDelete lock to the backend RG."
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to backend resources."
  default = {
    managedBy = "terraform"
    purpose   = "tfstate"
  }
}

