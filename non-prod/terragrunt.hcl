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
          version = "3.36.0"
        }
        azuread = {
          source = "hashicorp/azuread"
          version = "2.31.0"
        }
      }
#      required_version = "1.3.5"
      required_version = ">= 1.1.0"
    }
    provider "azurerm" {
        features {}
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
        use_oidc = true
        use_azuread_auth = true
        client_id = "${local.vars.TF_VAR_client_id}"
        tenant_id = "${local.vars.TF_VAR_tenant_id}"
        subscription_id = "${local.vars.TF_VAR_subscription_id}"
        }
    generate = {
        path      = "backend.tf"
        if_exists = "overwrite_terragrunt"
    }
}
