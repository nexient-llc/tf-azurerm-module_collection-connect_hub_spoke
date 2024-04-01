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

module "peer_firstVnet_to_secondVnet" {
  source = "git::https://github.com/launchbynttdata/tf-azurerm-module_primitive-vnet_peering.git?ref=1.0.0"

  peering_name                 = var.peer_firstVnet_to_secondVnet.peering_name
  resource_group_name          = var.peer_firstVnet_to_secondVnet.resource_group_name
  virtual_network_name         = var.peer_firstVnet_to_secondVnet.virtual_network_name
  remote_virtual_network_id    = var.peer_firstVnet_to_secondVnet.remote_virtual_network_id
  allow_virtual_network_access = var.peer_firstVnet_to_secondVnet.allow_virtual_network_access
  allow_forwarded_traffic      = var.peer_firstVnet_to_secondVnet.allow_forwarded_traffic
  allow_gateway_transit        = var.peer_firstVnet_to_secondVnet.allow_gateway_transit
  use_remote_gateways          = var.peer_firstVnet_to_secondVnet.use_remote_gateways
}

module "peer_secondVnet_to_firstVnet" {
  source = "git::https://github.com/launchbynttdata/tf-azurerm-module_primitive-vnet_peering.git?ref=1.0.0"

  peering_name                 = var.peer_secondVnet_to_firstVnet.peering_name
  resource_group_name          = var.peer_secondVnet_to_firstVnet.resource_group_name
  virtual_network_name         = var.peer_secondVnet_to_firstVnet.virtual_network_name
  remote_virtual_network_id    = var.peer_secondVnet_to_firstVnet.remote_virtual_network_id
  allow_virtual_network_access = var.peer_secondVnet_to_firstVnet.allow_virtual_network_access
  allow_forwarded_traffic      = var.peer_secondVnet_to_firstVnet.allow_forwarded_traffic
  allow_gateway_transit        = var.peer_secondVnet_to_firstVnet.allow_gateway_transit
  use_remote_gateways          = var.peer_secondVnet_to_firstVnet.use_remote_gateways
}
