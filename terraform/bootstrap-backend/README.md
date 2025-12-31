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

