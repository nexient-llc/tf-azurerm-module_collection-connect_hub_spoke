// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// virtual network peering connections
variable "peer_firstVnet_to_secondVnet" {
  description = "Virtual network peering connection from first vnet to second vnet"
  type = object({
    peering_name                 = string
    resource_group_name          = string
    virtual_network_name         = string
    remote_virtual_network_id    = string
    allow_virtual_network_access = bool
    allow_forwarded_traffic      = bool
    allow_gateway_transit        = bool
    use_remote_gateways          = bool
  })
}

variable "peer_secondVnet_to_firstVnet" {
  description = "Virtual network peering connection from first vnet to second vnet"
  type = object({
    peering_name                 = string
    resource_group_name          = string
    virtual_network_name         = string
    remote_virtual_network_id    = string
    allow_virtual_network_access = bool
    allow_forwarded_traffic      = bool
    allow_gateway_transit        = bool
    use_remote_gateways          = bool
  })
}

// resource name module
variable "resource_names_map_spoke" {
  description = "A map of key to resource_name that will be used by tf-module-resource_name to generate resource names"
  type = map(object({
    name       = string
    max_length = optional(number, 60)
    region     = optional(string, "eastus2")
  }))

  default = {}
}

variable "resource_names_map_hub" {
  description = "A map of key to resource_name that will be used by tf-module-resource_name to generate resource names"
  type = map(object({
    name       = string
    max_length = optional(number, 60)
    region     = optional(string, "eastus2")
  }))

  default = {}
}

variable "instance_env" {
  type        = number
  description = "Number that represents the instance of the environment."
  default     = 0

  validation {
    condition     = var.instance_env >= 0 && var.instance_env <= 999
    error_message = "Instance number should be between 0 to 999."
  }
}

variable "instance_resource" {
  type        = number
  description = "Number that represents the instance of the resource."
  default     = 0

  validation {
    condition     = var.instance_resource >= 0 && var.instance_resource <= 100
    error_message = "Instance number should be between 0 to 100."
  }
}

variable "logical_product_family" {
  type        = string
  description = <<EOF
    (Required) Name of the product family for which the resource is created.
    Example: org_name, department_name.
  EOF
  nullable    = false

  validation {
    condition     = can(regex("^[_\\-A-Za-z0-9]+$", var.logical_product_family))
    error_message = "The variable must contain letters, numbers, -, _, and .."
  }

  default = "launch"
}

variable "logical_product_service_spoke" {
  type        = string
  description = <<EOF
    (Required) Name of the product service for which the resource is created.
    For example, backend, frontend, middleware etc.
  EOF
  nullable    = false

  validation {
    condition     = can(regex("^[_\\-A-Za-z0-9]+$", var.logical_product_service_spoke))
    error_message = "The variable must contain letters, numbers, -, _, and .."
  }
}

variable "logical_product_service_hub" {
  type        = string
  description = <<EOF
    (Required) Name of the product service for which the resource is created.
    For example, backend, frontend, middleware etc.
  EOF
  nullable    = false

  validation {
    condition     = can(regex("^[_\\-A-Za-z0-9]+$", var.logical_product_service_hub))
    error_message = "The variable must contain letters, numbers, -, _, and .."
  }
}

variable "class_env" {
  type        = string
  description = "(Required) Environment where resource is going to be deployed. For example. dev, qa, uat"
  nullable    = false
  default     = "dev"

  validation {
    condition     = length(regexall("\\b \\b", var.class_env)) == 0
    error_message = "Spaces between the words are not allowed."
  }
}

//networking module for hub
# variable "network_map_hub" {
#   description = "Map of spoke networks where vnet name is key, and value is object containing attributes to create a network"
#   type = map(object({
#     use_for_each    = bool
#     address_space   = optional(list(string), ["10.0.0.0/16"])
#     subnet_names    = optional(list(string), ["subnet1", "subnet2", "subnet3"])
#     subnet_prefixes = optional(list(string), ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"])
#     bgp_community   = optional(string, null)
#     ddos_protection_plan = optional(object(
#       {
#         enable = bool
#         id     = string
#       }
#     ), null)
#     dns_servers                                           = optional(list(string), [])
#     nsg_ids                                               = optional(map(string), {})
#     route_tables_ids                                      = optional(map(string), {})
#     subnet_delegation                                     = optional(map(map(any)), {})
#     subnet_enforce_private_link_endpoint_network_policies = optional(map(bool), {})
#     subnet_enforce_private_link_service_network_policies  = optional(map(bool), {})
#     subnet_service_endpoints                              = optional(map(list(string)), {})
#     tags                                                  = optional(map(string), {})
#     tracing_tags_enabled                                  = optional(bool, false)
#     tracing_tags_prefix                                   = optional(string, "")
#   }))
# }

variable "network_map_hub" {
  description = "Attributes of virtual network to be created."
  type = object({
    use_for_each    = bool
    address_space   = optional(list(string), ["10.0.0.0/16"])
    subnet_names    = optional(list(string), [])
    subnet_prefixes = optional(list(string), [])
    bgp_community   = optional(string, null)
    ddos_protection_plan = optional(object(
      {
        enable = bool
        id     = string
      }
    ), null)
    dns_servers                                           = optional(list(string), [])
    nsg_ids                                               = optional(map(string), {})
    route_tables_ids                                      = optional(map(string), {})
    subnet_delegation                                     = optional(map(map(any)), {})
    subnet_enforce_private_link_endpoint_network_policies = optional(map(bool), {})
    subnet_enforce_private_link_service_network_policies  = optional(map(bool), {})
    subnet_service_endpoints                              = optional(map(list(string)), {})
    tags                                                  = optional(map(string), {})
    tracing_tags_enabled                                  = optional(bool, false)
    tracing_tags_prefix                                   = optional(string, "")
  })
}

variable "location" {
  description = "Azure region to use"
  type        = string
}

# variable "firewall_map" {
#   description = "Map of azure firewalls where name is key, and value is object containing attributes to create a azure firewall"
#   type = map(object({
#     logs_destinations_ids = list(string)
#     subnet_cidr           = optional(string)
#     additional_public_ips = optional(list(object(
#       {
#         name                 = string,
#         public_ip_address_id = string
#     })), [])
#     application_rule_collections = optional(list(object(
#       {
#         name     = string,
#         priority = number,
#         action   = string,
#         rules = list(object(
#           { name             = string,
#             source_addresses = list(string),
#             source_ip_groups = list(string),
#             target_fqdns     = list(string),
#             protocols = list(object(
#               { port = string,
#             type = string }))
#           }
#         ))
#     })))
#     custom_diagnostic_settings_name = optional(string)
#     custom_firewall_name            = optional(string)
#     dns_servers                     = optional(string)
#     extra_tags                      = optional(map(string))
#     firewall_private_ip_ranges      = optional(list(string))
#     ip_configuration_name           = optional(string)
#     network_rule_collections = optional(list(object({
#       name     = string,
#       priority = number,
#       action   = string,
#       rules = list(object({
#         name                  = string,
#         source_addresses      = list(string),
#         source_ip_groups      = optional(list(string)),
#         destination_ports     = list(string),
#         destination_addresses = list(string),
#         destination_ip_groups = optional(list(string)),
#         destination_fqdns     = optional(list(string)),
#         protocols             = list(string)
#       }))
#     })))
#     public_ip_zones = optional(list(number))
#     sku_tier        = string
#     zones           = optional(list(number))
#   }))
#   default = {}
# }

variable "firewall_map" {
  description = "Attributes to create a azure firewall"
  type = object({
    logs_destinations_ids = list(string)
    subnet_cidr           = optional(string)
    additional_public_ips = optional(list(object(
      {
        name                 = string,
        public_ip_address_id = string
    })), [])
    application_rule_collections = optional(list(object(
      {
        name     = string,
        priority = number,
        action   = string,
        rules = list(object(
          { name             = string,
            source_addresses = list(string),
            source_ip_groups = list(string),
            target_fqdns     = list(string),
            protocols = list(object(
              { port = string,
            type = string }))
          }
        ))
    })))
    custom_diagnostic_settings_name = optional(string)
    custom_firewall_name            = optional(string)
    dns_servers                     = optional(string)
    extra_tags                      = optional(map(string))
    firewall_private_ip_ranges      = optional(list(string))
    ip_configuration_name           = optional(string)
    network_rule_collections = optional(list(object({
      name     = string,
      priority = number,
      action   = string,
      rules = list(object({
        name                  = string,
        source_addresses      = list(string),
        source_ip_groups      = optional(list(string)),
        destination_ports     = list(string),
        destination_addresses = list(string),
        destination_ip_groups = optional(list(string)),
        destination_fqdns     = optional(list(string)),
        protocols             = list(string)
      }))
    })))
    public_ip_zones = optional(list(number))
    sku_tier        = string
    zones           = optional(list(number))
  })
  default = null
}

// Firewall Policy Rule Collection Group
variable "firewall_policy_rule_collection_group_priority" {
  description = "(Required) The priority of the Firewall Policy Rule Collection Group. The range is 100-65000."
  type        = number
}

variable "application_rule_collection" {
  description = "(Optional) The Application Rule Collection to use in this Firewall Policy Rule Collection Group."
  type = list(object({
    name     = string
    action   = string
    priority = number
    rule = list(object({
      name        = string
      description = optional(string)
      protocols = optional(list(object({
        type = string
        port = number
      })))
      http_headers = optional(list(object({
        name  = string
        value = string
      })))
      source_addresses      = optional(list(string))
      source_ip_groups      = optional(list(string))
      destination_addresses = optional(list(string))
      destination_urls      = optional(list(string))
      destination_fqdns     = optional(list(string))
      destination_fqdn_tags = optional(list(string))
      terminate_tls         = optional(bool)
      web_categories        = optional(list(string))
    }))
  }))
  default = []
}

variable "network_rule_collection" {
  description = "(Optional) The Network Rule Collection to use in this Firewall Policy Rule Collection Group."
  type = list(object({
    name     = string
    action   = string
    priority = number
    rule = list(object({
      name                  = string
      description           = optional(string)
      protocols             = list(string)
      destination_ports     = list(string)
      source_addresses      = optional(list(string))
      source_ip_groups      = optional(list(string))
      destination_addresses = optional(list(string))
      destination_fqdns     = optional(list(string))
    }))
  }))
  default = []

}

variable "nat_rule_collection" {
  description = "(Optional) The NAT Rule Collection to use in this Firewall Policy Rule Collection Group."
  type = list(object({
    name     = string
    action   = string
    priority = number
    rule = list(object({
      name               = string
      description        = optional(string)
      protocols          = list(string)
      source_addresses   = optional(list(string))
      source_ip_groups   = optional(list(string))
      destination_ports  = optional(list(string))
      translated_address = optional(string)
      translated_port    = number
      translated_fqdn    = optional(string)
    }))
  }))
  default = []
}

//networking module for spoke
variable "use_for_each" {
  type        = bool
  description = "Use `for_each` instead of `count` to create multiple resource instances."
  nullable    = false
}

variable "address_space" {
  type        = list(string)
  default     = ["10.0.0.0/16"]
  description = "The address space that is used by the virtual network."
}

variable "bgp_community" {
  type        = string
  default     = null
  description = "(Optional) The BGP community attribute in format `<as-number>:<community-value>`."
}

variable "ddos_protection_plan" {
  type = object({
    enable = bool
    id     = string
  })
  default     = null
  description = "The set of DDoS protection plan configuration"
}

# If no values specified, this defaults to Azure DNS
variable "dns_servers" {
  type        = list(string)
  default     = []
  description = "The DNS servers to be used with vNet."
}

variable "subnet_map" {
  type = map(object({
    subnet_prefixes                                       = list(string)
    subnet_enforce_private_link_service_network_policies  = bool
    subnet_enforce_private_link_endpoint_network_policies = bool
    subnet_service_endpoints                              = list(string)
    subnet_delegation                                     = map(map(any))
    route_table = object({
      routes = list(object({
        name                   = string
        address_prefix         = string
        next_hop_type          = string
        next_hop_in_ip_address = optional(string)
      }))
    })
    network_security_group = object({
      security_rules = list(object({
        name                                       = string
        protocol                                   = string
        access                                     = string
        priority                                   = number
        direction                                  = string
        description                                = optional(string)
        source_port_range                          = optional(string)
        source_port_ranges                         = optional(list(string))
        destination_port_range                     = optional(string)
        destination_port_ranges                    = optional(list(string))
        source_address_prefix                      = optional(string)
        source_address_prefixes                    = optional(list(string))
        source_application_security_group_ids      = optional(list(string))
        destination_address_prefix                 = optional(string)
        destination_address_prefixes               = optional(list(string))
        destination_application_security_group_ids = optional(list(string))
    })) })
  }))
  default     = null
  description = "A map of subnet configuration. The configuration contains subnet specific attributes, network security group and route table specific attributes."
}

variable "tracing_tags_enabled" {
  type        = bool
  default     = false
  description = "Whether enable tracing tags that generated by BridgeCrew Yor."
  nullable    = false
}

variable "tracing_tags_prefix" {
  type        = string
  default     = "avm_"
  description = "Default prefix for generated tracing tags"
  nullable    = false
}

variable "vnet_tags" {
  type        = map(string)
  default     = {}
  description = "The tags to associate with your network and subnets."
}
