# locals {
#   subscription_id   = "5d798471-bf04-46ec-8de0-8e42a4c1da3e"
# }

locals {
 vars        = yamldecode(file(("root.yaml"))
#  resource_group_name = get_env("resource_group_name")
#  subscription_id = local.vars.subscription_id
#  storage_account_name = local.vars.storage_account_name
#  container_name = local.vars.container_name
}

# Generate Azure providers
generate "providers" {
  path      = "providers.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
    terraform {
      required_providers {
        azurerm = {
          source = "hashicorp/azurerm"
          version = "3.36.0"
        }
      }
    }
    provider "azurerm" {
        features {}
        subscription_id = "${local.vars.TF_VAR_subscription_id}"
    }
EOF
}

remote_state {
    backend = "azurerm"
    config = {
        subscription_id = "${local.vars.TF_VAR_subscription_id}"
        key = "${path_relative_to_include()}terraform_new1.tfstate"
        resource_group_name = "${local.vars.TF_VAR_resource_group_name}"
        storage_account_name = "${local.vars.TF_VAR_storage_account_name}"
        container_name = "${local.vars.TF_VAR_container_name}"
    }
    generate = {
        path      = "backend.tf"
        if_exists = "overwrite_terragrunt"
    }
}
