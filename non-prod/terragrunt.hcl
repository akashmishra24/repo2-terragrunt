locals {
 vars = yamldecode(file("root.yaml"))
}

# Generate Azure providers
generate "providers" {
  path      = "providers.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
    terraform {
      required_providers {
       required_version = "1.3.6"
        azurerm = {
          source = "hashicorp/azurerm"
          version = "3.36.0"
        }
        azuread = {
          source = "hashicorp/azuread"
          version = "2.31.0"
        }
      }
    }
    provider "azurerm" {
        features {}
#         use_oidc         = true
#         use_azuread_auth = true
        subscription_id = "${local.vars.TF_VAR_subscription_id}"
    }
   provider "azuread" {}
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
        use_oidc         = true
        use_azuread_auth = true
        tenant_id = "${local.vars.TF_VAR_tenant_id}"
        client_id = "${local.vars.TF_VAR_client_id}"
    }
    generate = {
        path      = "backend.tf"
        if_exists = "overwrite_terragrunt"
    }
}
