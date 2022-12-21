locals {
  subscription_id   = "5d798471-bf04-46ec-8de0-8e42a4c1da3e"
}

# Generate Azure providers
generate "providers" {
  path      = "providers_override.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
    terraform {
      required_providers {
        azurerm = {
          source = "hashicorp/azurerm"
          version = "3.35.0"
        }
      }
    }
    provider "azurerm" {
        features {}
        subscription_id = "${local.subscription_id}"
    }
EOF
}

remote_state {
    backend = "azurerm"
    config = {
        subscription_id = "${local.subscription_id}"
        key = "${path_relative_to_include()}terraform_new1.tfstate"
        resource_group_name = "Terraform-State-File"
        storage_account_name = "mytfstatefile"
        container_name = "tfstate"
    }
    generate = {
        path      = "backend.tf"
        if_exists = "overwrite_terragrunt"
    }
}