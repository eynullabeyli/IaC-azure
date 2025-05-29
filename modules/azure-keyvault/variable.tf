variable "keyvault_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type        = string
  default     = "eastus"
}

variable "sku_name" {
  type        = string
  default     = "standard"
}

variable "tenant_id" {
  type        = string
}

variable "access_policies" {
  type        = list(object({
    tenant_id = string
    object_id = string
    permissions = object({
      secrets = list(string)
      keys    = list(string)
      certificates = list(string)
    })
  }))
  default = []
}

variable "enable_rbac_authorization" {
  type        = bool
  default     = false
}

variable "secrets" {
  type        = map(string)
  default     = {}
}