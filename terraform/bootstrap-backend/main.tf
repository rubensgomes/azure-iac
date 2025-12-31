# bootstrap-backend/main.tf
# "bootstrap-backend" module main root logic

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "tfstate" {
  name     = var.backend_resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_storage_account" "tfstate" {
  name                     = var.storage_account_id
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = var.replication_type
  account_kind             = "StorageV2"
  # hardening defaults
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false

  # Strongly recommended for Terraform state safety
  blob_properties {
    versioning_enabled = true

    delete_retention_policy {
      days = var.soft_delete_retention_days
    }

    container_delete_retention_policy {
      days = var.soft_delete_retention_days
    }
  }

  tags = var.tags
}

resource "azurerm_storage_container" "tfstate" {
  name                  = var.container_name
  storage_account_id    = azurerm_storage_account.tfstate.id
  container_access_type = "private"
}

# Give the identity running Terraform permission to read/write state blobs
# (For CI, you'd typically assign this to your pipeline identity instead.)
resource "azurerm_role_assignment" "state_blob_contributor" {
  scope                = azurerm_storage_account.tfstate.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}

# Optional: prevent accidental deletion of the backend RG
resource "azurerm_management_lock" "tfstate_rg_lock" {
  count      = var.enable_rg_lock ? 1 : 0
  name       = "tfstate-can-not-delete"
  scope      = azurerm_resource_group.tfstate.id
  lock_level = "CanNotDelete"
  notes      = "Protect Terraform remote state resources."
}

