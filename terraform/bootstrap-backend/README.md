# bootstrap-backend

This is the Terraform bootstrap stage (bootstrap-backend) operation which uses
local state to create the storage resources required by Terraform for storage.
This stage MUST be run prior to anything else!!!

This module is part of creating backend initial resources required by Terraform:

- resource group (e.g., rg-tfstate)
- storage account (e.g., sttfstaterubens01)
- storage container (e.g., tstate)

This module drives a separate bootstrap root module you run once with local
state, then everything else uses remote state. That is, this module commonly
does this “bootstrap first, then configure backend key per env.”

## Steps

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
