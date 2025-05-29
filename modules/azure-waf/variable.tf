variable "name_prefix" {
  description = "Prefix for naming resources"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group Name"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for the Application Gateway"
  type        = string
}

variable "capacity" {
  description = "Capacity of the Application Gateway"
  type        = number
  default     = 2
}

variable "waf_mode" {
  description = "WAF Mode (Detection or Prevention)"
  type        = string
  default     = "Prevention"
}

variable "rule_set_version" {
  description = "OWASP rule set version"
  type        = string
  default     = "3.2"
}

variable "ssl_cert_path" {
  description = "Path to the SSL certificate (.pfx)"
  type        = string
}

variable "ssl_cert_password" {
  description = "Password for the SSL certificate"
  type        = string
}

variable "backend_addresses" {
  description = "List of backend IP addresses"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
