output "waf_public_ip" {
  description = "Public IP of the WAF"
  value       = azurerm_public_ip.waf_public_ip.ip_address
}

output "waf_id" {
  description = "ID of the Application Gateway (WAF)"
  value       = azurerm_application_gateway.waf.id
}
