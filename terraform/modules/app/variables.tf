# modules/app/variables.tf
# modules/app reusable variables

variable "environment" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "tags" { type = map(string) }

variable "app_storage_account_prefix" {
  type        = string
  description = "Lowercase letters/numbers only. Keep short."
}

