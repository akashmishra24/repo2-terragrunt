plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

# terraform {
#   required_version = "1.3.5"
# }

plugin "azurerm" {
    enabled = true
    version = "0.20.0"
    source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}
