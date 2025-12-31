# terraform/phase1/providers.tf
# "phase1" providers shared by all modules

provider "azurerm" {
  # Auth via Service Principal + Secret environment variables:
  # ARM_SUBSCRIPTION_ID, ARM_TENANT_ID, ARM_CLIENT_ID, ARM_CLIENT_SECRET
  features {}
}
