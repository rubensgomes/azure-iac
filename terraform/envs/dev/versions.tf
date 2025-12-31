# envs/dev/versions.tf
# envs/dev module versions

terraform {
  required_version = "~> 1.14"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.57"
    }
  }

  # backend config is supplied via -backend-config=backend.hcl
  backend "azurerm" {}
}

