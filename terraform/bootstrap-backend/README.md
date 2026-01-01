# terraform/bootstrap-backend/README.md

This is the Terraform bootstrap stage (bootstrap-backend) moule. This module
implements Terraform operations which using local state to create the resource
group and storage resources required by Terraform. This stage MUST be run prior
to anything else, and it is therefore named "bootstrap-backend".

The following Terraform backend initial resources are created:

- resource group (e.g., rg-tfstate)
- storage account (e.g., sttfstaterubens01)
- storage container (e.g., tstate)

Once this module is run, Terraform will be able to use the corresponding
blob storage to store the state files of Terraform configurations.

## Configuration Steps

1. Ensure ARM credential environment variables are found:

    ```bash
    env | grep ARM
    # should display:
    # ARM_CLIENT_ID=<SECRET_INFO>
    # ARM_TENANT_ID=<SECRET_INFO>
    # ARM_CLIENT_SECRET=<SECRET_INFO>
    # ARM_SUBSCRIPTION_ID=<SECRET_INFO>
    ```

2. Ensure the storage_account_id is available:

    ```bash
    az login
    STORAGE_ACCOUNT_ID="sttfstaterubens01"
    az storage account check-name  \
      --name ${STORAGE_ACCOUNT_ID} \
      --query nameAvailable -o tsv
    # returns true if available; false, otherwise.
    ```

3. Bootstrap backend by creating the Terraform remote state backend (one-time)

    ```bash
    cd $(git rev-parse --show-toplevel) || exit
    cd terraform/bootstrap-backend
    terraform init --upgrade || exit
    terraform validate || exit
    export TF_LOG=INFO
    terraform plan -out bootstrap.tfplan || exit
    terraform apply bootstrap.tfplan
    ```

4. To destroy the above applied plan:

    ```bash
    cd $(git rev-parse --show-toplevel) || exit
    cd terraform/bootstrap-backend
    export TF_LOG=INFO
    terraform destroy -auto-approve
    ```

## Issue with Terraform local state

Terraform only manages what’s recorded in its state file. If the state doesn’t
contain the RG, Terraform assumes it doesn’t exist and tries to create it. Azure
rejects that because it already exists, and Terraform tells you to import.

That means Terraform is using the local backend. In GitHub Actions, runners are
ephemeral, so unless you persist the state somehow, each run starts with an
empty state → destroy can’t destroy anything and apply tries to recreate
existing resources, which then fails. This is exactly why pipelines that use
local state on ephemeral runners often fail on the second run.

To fix the issue we need to import the existing resources (e.g., resource group,
storage account, and container name) into Terraform local state:

   ```bash
   terraform init --upgrade
   export RG_NAME="rg-tfstate"
   export STORAGE_ACCOUNT_ID="sttfstaterubens01"
   export CONTAINER_NAME="tfstate"
   # import resource group
   terraform import azurerm_resource_group.tfstate \
      "/subscriptions/${ARM_SUBSCRIPTION_ID}/resourceGroups/${RG_NAME}"
   # import storage account
   terraform import azurerm_storage_account.tfstate \
      "/subscriptions/${ARM_SUBSCRIPTION_ID}/resourceGroups/${RG_NAME}/providers/Microsoft.Storage/storageAccounts/${STORAGE_ACCOUNT_ID}"
   # import container name
   terraform import azurerm_storage_container.tfstate \
      "https://${STORAGE_ACCOUNT_ID}.blob.core.windows.net/${CONTAINER_NAME}"
   terraform plan -out=bootstrap.tfplan
   terraform apply bootstrap.tfplan
   ````

## Migrate Terraform Local State to Azure Cloud Blob Storage

In order to store the bootstrap-backend Terraform state in the Azure Storage
account/container, first ensure you have successfully created the above backend
initial resources.

The “gotcha” here is the classic chicken‑and‑egg problem: you can’t use an Azure
Blob backend until the storage account/container exist. Once you've already
created them (using local state), you’re now in the perfect position to migrate
that local state into the blob container.

1. Ensure you have created Terraform backend storage resources (e.g., resource
   group, storage account, and container) in Azure
2. Ensure 'bootstrap-backend/backend.tf' has the following:

   ```text
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
   ```

3. Run the following command locally:

   ```bash
   # answer yes at the prompt
   terraform init -migrate-state
   ```

## Destroying the Terraform Backend

NEVER DESTROY THE BACKEND WHILE USING TERRAFORM TO STORE STATE ON THE BACKEND.
FROM NOW ON DO NOT EVER REMOVE THE BACKEND RESOURCES UNLESS YOU FOLLOW A VERY
RIGOROUS PROCEDURE BEFORE DOING SO.

Before destroying bootstrap backend resources, always do:

- Migrate state back to local first (safe teardown)
- Change backend to local
- terraform init -migrate-state
- terraform destroy