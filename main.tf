data "azurerm_client_config" "current" {}

module "resource_group" {
  source              = "./modules/azure-resource-group"
  resource_group_name = "EMVP-rg-test"
  location            = "eastus"
}

module "vnet" {
  source = "./modules/azure-vnet"

  vnet_name           = "EMVP-vnet-test"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.resource_group_name
  address_space       = "11.49.0.0/18"

  tags = {
    "APPLICATION CODE"     = "EMVP"
    "application"          = "Enrich MVP"
    "BUSINESS OWNER"       = "Allan Flott"
    "technicalfocalpoint"  = "Allan Flott"
  }
}

module "subnets" {
  source               = "./modules/azure-subnet"
  resource_group_name  = module.resource_group.resource_group_name
  virtual_network_name = module.vnet.vnet_name
  subnets = {
    "snet-webapp" = {
      address_prefix = "11.49.0.0/24"
      service_endpoints = ["Microsoft.Web"]
      delegations = [{
        service_name = "Microsoft.Web/serverFarms"
        actions      = ["Microsoft.Network/virtualNetworks/subnets/action"]
      }]
      private_endpoint_network_policies = "Enabled"
    }
    "snet-sql" = {
      address_prefix = "11.49.1.0/24"
      private_endpoint_network_policies = "Disabled"
    }
    "snet-storage" = {
      address_prefix = "11.49.2.0/24"
      private_endpoint_network_policies = "Disabled"
    }
    "snet-vm" = {
      address_prefix = "11.49.3.0/24"
      private_endpoint_network_policies = "Disabled"
    }
    "sb-acr" = {
      address_prefix = "11.49.4.0/24"
      private_endpoint_network_policies = "Disabled"
    }
    "AzureBastionSubnet" = {
      address_prefix = "11.49.5.0/24"
      private_endpoint_network_policies = "Disabled"
    }
    "snet-waf" = {
      address_prefix = "11.49.6.0/24"
      private_endpoint_network_policies = "Disabled"
    }
  }
}

module "waf" {
  source              = "./modules/azure-waf"
  count               = 0
  name_prefix         = "EMVP-T"
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.location
  subnet_id           = module.subnets.subnet_ids["snet-waf"]
  ssl_cert_path       = "certificate/cert_examplee.pfx"
  ssl_cert_password   = "cert_pass_Exampleee"
  backend_addresses   = ["11.49.0.4"]

  tags = {
    "APPLICATION CODE"     = "EMVP"
    "application"          = "Enrich MVP"
    "BUSINESS OWNER"       = "Allan Flott"
    "technicalfocalpoint"  = "Allan Flott"
  }
}

module "azure-service-plan" {
  source              = "./modules/azure-service-plan"
  name                = "EMVP-plan-test"
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.location
  sku_name            = "P1v2"
  capacity            = 1
  depends_on = [ module.resource_group ]
}

module "azure-app-service" {
  source              = "./modules/azure-app-service"
  app_service_name    = "EMVP-app-service-test"
  resource_group_name = module.resource_group.resource_group_name
  service_plan_id     = module.azure-service-plan.app_service_plan_id
  location            = module.resource_group.location
  depends_on          = [module.azure-service-plan]
}

module "azure_keyvault" {
  source = "./modules/azure-keyvault"
  count = 0
  keyvault_name            = "EMVP-keyvault"
  resource_group_name      = module.resource_group.resource_group_name
  location                 = module.resource_group.location
  sku_name                 = "standard"
  tenant_id                = data.azurerm_client_config.current.tenant_id
  enable_rbac_authorization = false
  secrets = {
    "FirstSecret" = "0BigSecret***"
  }
}

module "sql_server" {
  source              = "./modules/azure-sql-server"
  sql_server_name     = "emvp-sql-server-test"
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.location
  admin_username      = "admin"
  admin_password      = "password"
  database_name       = "EMVP-db-test"
  database_max_size_gb = 10
  sku_name            = "S1"
  subnet_id           = module.subnets.subnet_ids["snet-sql"]
  
  firewall_rules = {
    "AllowHome" = {
      start_ip = "192.168.1.1"
      end_ip   = "192.168.1.255"
    }
  }
}

module "network_watcher" {
  source = "./modules/azure-network-watcher"
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.location
  name                = "EMVP-network-watcher"
}

module "vnet_flow_log" {
  source = "./modules/azure-vnet-flow-log"
  
  resource_group_name        = module.resource_group.resource_group_name
  location                   = module.resource_group.location
  flow_log_name              = "EMVP-vnet-flow-log"
  enabled                    = true
  storage_account_id         = var.storage_account_id
  network_security_group_id  = var.network_security_group_id
  log_analytics_workspace_id = var.log_analytics_workspace_id
  workspace_region           = var.workspace_region
  workspace_resource_id      = var.workspace_resource_id
  traffic_analytics_enabled  = true
  retention_days             = 30
}
