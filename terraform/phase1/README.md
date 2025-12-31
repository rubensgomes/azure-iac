# terraform/phase1/README.md

The phase 1 creates shared foundation Azure infrastructure resources to be
reused by all microservices. Later phases (e.g., phase 2) will create more
specific resource like database.

The following infrastructure resources are deployed in this phase:

- Resource group
- VNet + subnets for:
    - ACA infrastructure subnet (for ACA environment VNet integration)
    - PostgreSQL delegated subnet (for private PostgreSQL Flexible Server later)

- Log Analytics workspace to be used by ACA logs
- External Azure Container Apps environment (VNet-integrated)
- Azure Container Registry for dockerized images storage

This phase intentionally does NOT deploy:

- PostgreSQL Flexible Server (that is Phase 3)
- Azure App Configuration / Key Vault (Phase 2 or later)
- Azure Front Door WAF (Phase 2 or later)
- Any Container Apps (microservices) (later phases)

## Authentication

This phase assumes Terraform authenticates to Azure using `Service Principal + 
client secret` via environment vars:

- ARM_SUBSCRIPTION_ID
- ARM_TENANT_ID
- ARM_CLIENT_ID
- ARM_CLIENT_SECRET

## Storing Terraform State in Blob Storage

- Confirm the storage account + container exist:

  ```bash
  EXPECTED_RG_NAME="rg-tfstate"
  EXPECTED_STORAGE_ACCOUNT_NAME="sttfstaterubens01"
  EXPECTED_CONTAINER_NAME="tfstate"
  az account set --subscription "$ARM_SUBSCRIPTION_ID"
  # check storage account
  az storage account show \
    -g "${EXPECTED_RG_NAME}" \
    -n "${EXPECTED_STORAGE_ACCOUNT_NAME}" \
    -o table
  # check container
  az storage container show \
    --account-name "${EXPECTED_STORAGE_ACCOUNT_NAME}" \
    --name "${EXPECTED_CONTAINER_NAME}" \
    -o table
  ```