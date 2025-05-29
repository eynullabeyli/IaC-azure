variable "resource_group_name" {
  description = "Resource Group Name"
  type        = string
}

variable "virtual_network_name" {
  description = "Virtual Network Name"
  type        = string
}

variable "subnets" {
  description = "Map of subnets with configurations"
  type = map(object({
    address_prefix                    = string
    service_endpoints                 = optional(list(string), [])
    delegations                       = optional(list(object({
      service_name = string
      actions      = list(string)
    })), [])
    private_endpoint_network_policies = optional(string, "Enabled")
  }))
}
