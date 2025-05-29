resource "azurerm_network_watcher_flow_log" "vnet_flow_logs" {
  name                   = var.flow_log_name
  resource_group_name    = var.resource_group_name
  location               = var.location
  network_watcher_name   = azurerm_network_watcher.main.name
  enabled                = var.enabled
  traffic_analytics {
    enabled             = var.traffic_analytics_enabled
    workspace_id        = var.log_analytics_workspace_id
    workspace_region    = var.workspace_region
    workspace_resource_id = var.workspace_resource_id
  }

  storage_account_id = var.storage_account_id
  target_resource_id = var.network_security_group_id

  retention_policy {
    days    = 30
    enabled = true
  }

  depends_on = [azurerm_network_watcher.main]
}
