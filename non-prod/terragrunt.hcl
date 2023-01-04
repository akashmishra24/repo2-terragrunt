locals {
 vars = yamldecode(file("root.yaml"))
}

generate "providers" {
  path      = "providers.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
    terraform {
      required_providers {
        azurerm = {
          source = "hashicorp/azurerm"
          version = "3.30.0"
        }
        azuread = {
          source = "hashicorp/azuread"
          version = "2.31.0"
        }
      }
      required_version = ">= 1.1.0"
    }
    provider "azurerm" {
        features {
        key_vault {
         recover_soft_deleted_key_vaults = false
         purge_soft_delete_on_destroy    = false
        }
        }
        subscription_id = "${local.vars.TF_VAR_subscription_id}"
        client_id = "${local.vars.TF_VAR_client_id}"
        tenant_id = "${local.vars.TF_VAR_tenant_id}"
        use_msi = true
        use_oidc = true
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
         use_oidc = true
         use_msi = true
         client_id = "${local.vars.TF_VAR_client_id}"
         tenant_id = "${local.vars.TF_VAR_tenant_id}"
         subscription_id = "${local.vars.TF_VAR_subscription_id}"
        }
    generate = {
        path      = "backend.tf"
        if_exists = "overwrite_terragrunt"
    }
}
