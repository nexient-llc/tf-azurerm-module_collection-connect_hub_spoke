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
  description = "Virtual network peering connection from hub to spoke"
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
  description = "Virtual network peering connection from hub to spoke"
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
