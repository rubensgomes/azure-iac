# envs/dev/outputs.tf
# envs/dev module outputs

output "env_resource_group_name" {
  value = azurerm_resource_group.env.name
}

output "app_storage_account_name" {
  value = module.app.storage_account_name
}

