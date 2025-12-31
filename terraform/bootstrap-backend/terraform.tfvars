# bootstrap-backend/terraform.tfvars
# "bootstrap-backend" module constants

# pre-defined parameters
location                    = "eastus"
backend_resource_group_name = "rg-tfstate"
# storage account id needs to be globally unique
storage_account_id = "sttfstaterubens01"
container_name     = "tfstate"
# Locally Redundant Storage (LRS) for lowest cost
replication_type = "LRS"
# free/disposable account. I only need a short time
soft_delete_retention_days = 2
# Disable lock to keep Terraform create/destroy simple
enable_rg_lock = false

