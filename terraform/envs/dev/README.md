# envs/dev/ — file contents

This is the dev environment root module. It:

- Creates a dev resource group
- Deploys a small example module (modules/app)
- Uses remote state in the shared container tfstate with key = 
  envs/dev/terraform.tfstate
