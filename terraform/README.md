# terraform/README.md

This file describes credential configuration steps required to allow Terraform
to authenticate against Microsoft Azure Cloud.

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
    
    az role assignment create \
      --assignee-object-id "${SP_OBJECT_ID}" \
      --assignee-principal-type ServicePrincipal \
      --role "User Access Administrator" \
      --scope "/subscriptions/${AZURE_SUBSCRIPTION_ID}"
    ```

4. Verify the Service Principal has both roles:

    ```bash
    SP_OBJECT_ID="<SECRET_INFO>"
    AZURE_SUBSCRIPTION_ID="<SECRET_INFO>"
    
    az role assignment list \
      --assignee-object-id "${SP_OBJECT_ID}" \
      --scope "/subscriptions/${AZURE_SUBSCRIPTION_ID}" \
      -o table
    ```

5. Save the credentials to the environment:

    ```bash
    export ARM_CLIENT_ID='<SECRET_INFO>
    export ARM_CLIENT_SECRET='<SECRET_INFO>'
    export ARM_SUBSCRIPTION_ID='<SECRET_INFO>'
    export ARM_TENANT_ID='<SECRET_INFO>'
    ```

6. Also, save the credentials to the corresponding GitHub repo:

    ```text
    "azure-iac" Repo → Settings → Environments → AZURE → Environment secrets 
    
    AZURE_CLIENT_ID='<SECRET_INFO>'
    AZURE_CLIENT_SECRET='<SECRET_INFO>'
    AZURE_SUBSCRIPTION_ID='<SECRET_INFO>'
    AZURE_TENANT_ID='<SECRET_INFO>'
    ```
