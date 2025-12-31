# terraform/README.md

This file describes pre-requisite configuration steps required to allow Terraform
to authenticate and create resources in Microsoft Azure Cloud.

## Service Principal and Secrets

We are using a `Service Principal + Secrets` to allow Terraform to authenticate
against Azure. Also, since Terraform is assigning roles to some resource, this
`Service Principal` must have the `User Access Administrator` role assigned to
it.

1. Create a Service Principal:

    ```bash
    az login
    export AZURE_SUBSCRIPTION_ID='<SECRET_INFO>'
    az ad sp create-for-rbac \
      --name "sp-rubens" \
      --role "Contributor" \
      --scopes "/subscriptions/${AZURE_SUBSCRIPTION_ID}" \
      --verbose
    # The output includes:
    # appId  → ARM_CLIENT_ID/AZURE_CLIENT_ID          : <SECRET_INFO>
    # password → ARM_CLIENT_SECRET/AZURE_CLIENT_SECRET: <SECRET_INFO>
    # tenant → ARM_TENANT_ID/AZURE_TENANT_ID          : <SECRET_INFO>
    ```

2. Display the Service Principal Object Id:

    ```bash
    az login
    AZURE_CLIENT_ID='<SECRET_INFO>'
    # displays the object id:
    az ad sp show --id "${AZURE_CLIENT_ID}" --query id -o tsv
    # SP_OBJECT_ID='<SECRET_INFO>'
    ```

3. Add "User Access Administrator" role:

    ```bash
    SP_OBJECT_ID="<SECRET_INFO>"
    AZURE_SUBSCRIPTION_ID="<SECRET_INFO>"
    EXPECTED_RG_NAME="rg-tfstate"
    EXPECTED_STORAGE_ACCOUNT_NAME="sttfstaterubens01"
    EXPECTED_CONTAINER_NAME="tfstate"
    SCOPE="/subscriptions/${ARM_SUBSCRIPTION_ID}"
    az role assignment create \
      --assignee-object-id "${SP_OBJECT_ID}" \
      --assignee-principal-type ServicePrincipal \
      --role "User Access Administrator" \
      --scope "${SCOPE}"
    ```

4. Add "Storage Blob Data Contributor" role:

    ```bash
    SP_OBJECT_ID="<SECRET_INFO>"
    AZURE_SUBSCRIPTION_ID="<SECRET_INFO>"
    EXPECTED_RG_NAME="rg-tfstate"
    EXPECTED_STORAGE_ACCOUNT_NAME="sttfstaterubens01"
    EXPECTED_CONTAINER_NAME="tfstate"
    SCOPE="/subscriptions/${ARM_SUBSCRIPTION_ID}/resourceGroups/${EXPECTED_RG_NAME}/providers/Microsoft.Storage/storageAccounts/${EXPECTED_STORAGE_ACCOUNT_NAME}"
    az role assignment create \
      --assignee-object-id "${SP_OBJECT_ID}" \
      --assignee-principal-type ServicePrincipal \
      --role "Storage Blob Data Contributor" \
      --scope "${SCOPE}"
    ```

5. Verify the Service Principal has the expected roles for the right scopes:

    ```bash
    SP_OBJECT_ID="<SECRET_INFO>"
    AZURE_SUBSCRIPTION_ID="<SECRET_INFO>"
    SCOPE1="/subscriptions/${ARM_SUBSCRIPTION_ID}"
    az role assignment list \
      --assignee-object-id "${SP_OBJECT_ID}" \
      --scope "${SCOPE1}" \
      -o table
    SCOPE2="/subscriptions/${ARM_SUBSCRIPTION_ID}/resourceGroups/${EXPECTED_RG_NAME}/providers/Microsoft.Storage/storageAccounts/${EXPECTED_STORAGE_ACCOUNT_NAME}"
    az role assignment list \
      --assignee-object-id "${SP_OBJECT_ID}" \
      --scope "${SCOPE2}" \
      -o table
    ```

6. Save the credentials to the environment:

    ```bash
    export ARM_CLIENT_ID='<SECRET_INFO>
    export ARM_CLIENT_SECRET='<SECRET_INFO>'
    export ARM_SUBSCRIPTION_ID='<SECRET_INFO>'
    export ARM_TENANT_ID='<SECRET_INFO>'
    ```

7. Also, save the credentials to the corresponding GitHub repo:

    ```text
    "azure-iac" Repo → Settings → Environments → AZURE → Environment secrets 
    AZURE_CLIENT_ID='<SECRET_INFO>'
    AZURE_CLIENT_SECRET='<SECRET_INFO>'
    AZURE_SUBSCRIPTION_ID='<SECRET_INFO>'
    AZURE_TENANT_ID='<SECRET_INFO>'
    ```

## Register the Microsoft.App resource provider

Azure services are exposed through `Resource Providers` (RPs). And the Azure
Container Apps uses the `Microsoft.App` resource provider. Therefore, the 
subscription must have that `Microsoft.App`  RP registered before Terraform 
can create an azurerm_container_app_environment.

- Register `Microsoft.App` RP as follows:

   ```bash
   az login
   az account set --subscription "${ARM_SUBSCRIPTION_ID}"
   # Register Container Apps RP
   az provider register --namespace Microsoft.App
   # Optional: check registration status
   az provider show --namespace Microsoft.App --query "registrationState" -o tsv
   ```

- Register the other RPs you’ll certainly need for Phase 1/next phases:

   ```bash
   az provider register --namespace Microsoft.OperationalInsights   # Log Analytics
   az provider register --namespace Microsoft.ContainerRegistry     # ACR
   az provider register --namespace Microsoft.Network              # VNets/Subnets
   az provider register --namespace Microsoft.KeyVault             # Key Vault (Phase 2)
   az provider register --namespace Microsoft.AppConfiguration     # App Config (Phase 2)
   az provider register --namespace Microsoft.DBforPostgreSQL      # PostgreSQL (Phase 3)
   az provider register --namespace Microsoft.Cdn                  # Front Door (Phase 2)
   ```