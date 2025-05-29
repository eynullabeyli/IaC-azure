data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "example" {
  name                        = "EMVP-keyvault"
  location                    = var.location
  resource_group_name         = "EMVP-rg-test"
  sku_name                    = var.sku_name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  enable_rbac_authorization   = var.enable_rbac_authorization

  dynamic "access_policy" {
    for_each = var.access_policies
    content {
      tenant_id = access_policy.value.tenant_id
      object_id = access_policy.value.object_id
      secret_permissions = access_policy.value.permissions.secrets
      key_permissions    = access_policy.value.permissions.keys
      certificate_permissions = access_policy.value.permissions.certificates
    }
  }
}

resource "azurerm_key_vault_secret" "secrets" {
  for_each = var.secrets
  name     = each.key
  value    = each.value
  key_vault_id = azurerm_key_vault.example.id
}
