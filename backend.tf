terraform {
  backend "azurerm" {
    resource_group_name  = "emvp-iac-tfm-state-data-eus-rg"  # Can be passed via `-backend-config=`"resource_group_name=<resource group name>"` in the `init` command.
    storage_account_name = "tfmstatedata"                      # Can be passed via `-backend-config=`"storage_account_name=<storage account name>"` in the `init` command.
    container_name       = "tfstate-remote-backend-modules"                       # Can be passed via `-backend-config=`"container_name
    key                  = "prod.modules.terraform.tfstate"
  }
}