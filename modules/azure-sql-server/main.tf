resource "azurerm_mssql_server" "sql_server" {
  name                         = var.sql_server_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.admin_username
  administrator_login_password = var.admin_password

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_mssql_database" "sql_database" {
  name           = var.database_name
  server_id      = azurerm_mssql_server.sql_server.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = var.database_max_size_gb
  sku_name       = var.sku_name
  zone_redundant = var.zone_redundant
}

resource "azurerm_mssql_firewall_rule" "allow_access" {
  for_each = var.firewall_rules

  name             = each.key
  server_id        = azurerm_mssql_server.sql_server.id
  start_ip_address = each.value.start_ip
  end_ip_address   = each.value.end_ip
}
