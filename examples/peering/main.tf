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


module "network-peering" {
  source = "../.."

  peer_firstVnet_to_secondVnet = var.peer_firstVnet_to_secondVnet
  peer_secondVnet_to_firstVnet = var.peer_secondVnet_to_firstVnet

  depends_on = [module.hub_vnet, module.spoke_network]
}

module "spoke_network" {
  source = "git::https://github.com/launchbynttdata/tf-azurerm-module_collection-spoke_network.git?ref=1.0.0"

  resource_names_map      = var.resource_names_map_spoke
  instance_env            = var.instance_env
  instance_resource       = var.instance_resource
  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service_spoke
  location                = var.location
  class_env               = var.class_env
  address_space           = var.address_space
  bgp_community           = var.bgp_community
  ddos_protection_plan    = var.ddos_protection_plan
  dns_servers             = var.dns_servers
  subnet_map              = var.subnet_map
  tracing_tags_enabled    = var.tracing_tags_enabled
  tracing_tags_prefix     = var.tracing_tags_prefix
  use_for_each            = var.use_for_each
}

module "hub_vnet" {
  source = "git::https://github.com/launchbynttdata/tf-azurerm-module_collection-hub_network.git?ref=1.0.0"

  resource_names_map      = var.resource_names_map_hub
  instance_env            = var.instance_env
  class_env               = var.class_env
  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service_hub
  instance_resource       = var.instance_resource
  location                = var.location

  network                                        = var.network_map_hub
  firewall                                       = var.firewall_map
  firewall_policy_rule_collection_group_priority = var.firewall_policy_rule_collection_group_priority
  application_rule_collection                    = var.application_rule_collection
  network_rule_collection                        = var.network_rule_collection
  nat_rule_collection                            = var.nat_rule_collection
}
