include "root" {
  path = find_in_parent_folders()
}
# Change

terraform {
    source = "git::https://github.com/akashmishra24/repo1-tfmodules.git//storage_account_module"
}

inputs = {
  resource_group_name = "rg-iac-cox-poc-01"

storage_accounts = {
  atstftststorageacct = {
    name         = "atstftststorageacct",
    sku          = "Standard_LRS",
    account_kind = "StorageV2",
    access_tier  = "Hot",
    network_rules = {
      bypass                     = ["None"],
      default_action             = "Allow",
      ip_rules                   = [],
      virtual_network_subnet_ids = []
    },
    managed_identity_type   = "SystemAssigned"
    enable_large_file_share = false,
  }
}

tags = {
  "date" = "12/29/2022"
}

containers = {
  tfTstStorageContainer = {
    name                  = "tftststoragecontainer",
    storage_account_name  = "atstftststorageacct",
    container_access_type = "container"
  }
}
}
