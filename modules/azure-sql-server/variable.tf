variable "sql_server_name" {
  type        = string
}

variable "resource_group_name" {
  type        = string
}

variable "location" {
  type        = string
}

variable "admin_username" {
  type        = string
}

variable "admin_password" {
  type        = string
  sensitive   = true
}

variable "database_name" {
  type        = string
}

variable "database_max_size_gb" {
  type        = number
  default     = 5
}

variable "sku_name" {
  type        = string
  default     = "S0"
}

variable "zone_redundant" {
  type        = bool
  default     = false
}

variable "firewall_rules" {
  type = map(object({
    start_ip = string
    end_ip   = string
  }))
  default = {}
}
variable "subnet_id" {
  type        = string
}
