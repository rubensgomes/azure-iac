# bootstrap-backend/backend.tf
# "bootstrap-backend" module backend storage

terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "sttfstaterubens01"
    container_name       = "tfstate"

    # IMPORTANT: choose a unique key for the BOOTSTRAP state.
    # Do not reuse the same key as your phase1 state.
    key = "bootstrap/backend.tfstate"

    # We want to use SP + Secrets to access the Blob Storage
    use_azuread_auth = false
  }
}
