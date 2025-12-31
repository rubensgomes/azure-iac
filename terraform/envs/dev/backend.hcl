# This HCL configuration file is used exclusively to provide settings to 
# create resources (e.g., resource group, storage account, container) to
# be used by Terraform.
#
# This file is not Terraform language; it’s backend config used by
# "terraform init -backend-config=backend.hcl".
#
# Why .hcl file? Because Terraform backends don’t accept normal input
# variables (var.*) inside the backend "azurerm" {} block, so you pass
# values at init-time. This is standard practice in backend examples.

# an exclusive resource group used for Terraform purposes only.
resource_group_name  = "rg-tfstate"

# deterministic storage account name being used.
storage_account_id   = "sttfstaterubens01"
container_name       = "tfstate"
key                  = "rubens/dev/terraform.tfstate"

# We do NOT want to authenticate Terraform to Azure Cloud using Microsoft
# Entra ID (Azure AD). Instead, we will use the service principal credentials
# passing them as part of environment variables:
# export ARM_CLIENT_ID='<SECRET_INFO>'
# export ARM_TENANT_ID='<SECRET_INFO>'
# export ARM_CLIENT_SECRET='<SECRET_INFO>'
# export ARM_SUBSCRIPTION_ID='<SECRET_INFO>' 
use_azuread_auth     = false

