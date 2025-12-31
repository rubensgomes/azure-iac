# bootstrap-backend/versions.tf
# terraform + provider versions used by the "bootstrap-backend"
terraform {
  required_version = "~> 1.14"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.57"
    }
  }
}

