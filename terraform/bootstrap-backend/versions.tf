# bootstrap-backend/versions.tf
# "bootstrap-backend" module  provider versions

terraform {
  required_version = "~> 1.14"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.57"
    }
  }
}

