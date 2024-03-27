
peer_firstVnet_to_secondVnet = {
  peering_name                 = "peer_hub_to_spoke"
  resource_group_name          = "launch-hub-eastus2-sandbox-000-rg-000"
  virtual_network_name         = "launch-hub-eastus2-sandbox-000-vnet-000"
  remote_virtual_network_id    = "/subscriptions/e71eb3cd-83f2-46eb-8f47-3b779e27672f/resourceGroups/launch-spoke-eastus2-sandbox-000-rg-000/providers/Microsoft.Network/virtualNetworks/launch-spoke-eastus2-sandbox-000-vnet-000"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}
peer_secondVnet_to_firstVnet = {
  peering_name                 = "peer_spoke_to_hub"
  resource_group_name          = "launch-spoke-eastus2-sandbox-000-rg-000"
  virtual_network_name         = "launch-spoke-eastus2-sandbox-000-vnet-000"
  remote_virtual_network_id    = "/subscriptions/e71eb3cd-83f2-46eb-8f47-3b779e27672f/resourceGroups/launch-hub-eastus2-sandbox-000-rg-000/providers/Microsoft.Network/virtualNetworks/launch-hub-eastus2-sandbox-000-vnet-000"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

logical_product_service_spoke = "spoke"
logical_product_family        = "launch"
class_env                     = "sandbox"
instance_env                  = 0
instance_resource             = 0
location                      = "eastus2"
resource_names_map_spoke = {
  resource_group = {
    name       = "rg"
    max_length = 80
  }
  spoke_vnet = {
    name       = "vnet"
    max_length = 80
  }
  network_security_group = {
    name       = "spokensg"
    max_length = 80
  }
  route_table = {
    name       = "spokert"
    max_length = 80
  }
  spoke_subnet = {
    name       = "spokesubnt"
    max_length = 80
  }
}
logical_product_service_hub = "hub"
resource_names_map_hub = {
  resource_group = {
    name       = "rg"
    max_length = 80
  }
  spoke_vnet = {
    name       = "vnet"
    max_length = 80
  }
  network_security_group = {
    name       = "spokensg"
    max_length = 80
  }
  route_table = {
    name       = "spokert"
    max_length = 80
  }
  resource_group = {
    name       = "rg"
    max_length = 80
  }
  hub_vnet = {
    name       = "vnet"
    max_length = 80
  }
  firewall = {
    name       = "fw"
    max_length = 80
  }
  firewall_policy = {
    name       = "fwplcy"
    max_length = 80
  }
  fw_plcy_rule_colln_grp = {
    name       = "fwplcyrulecollngrp"
    max_length = 80
  }
  public_ip = {
    name       = "pip"
    max_length = 80
  }
  hub_vnet_ip_configuration = {
    name       = "ipconfig"
    max_length = 80
  }
  custom_diagnostic_settings = {
    name       = "fwdiag"
    max_length = 80
  }
  log_analytics_workspace = {
    name       = "law"
    max_length = 80
  }
  monitor_diagnostic_setting = {
    name       = "fwds"
    max_length = 80
  }
}
network_map_hub = {
  use_for_each    = false
  address_space   = ["10.0.0.0/16"]
  subnet_names    = []
  subnet_prefixes = []
}
firewall_map = {
  logs_destinations_ids = []
  subnet_cidr           = "10.0.1.0/24"
  additional_public_ips = []
  sku_tier              = "Standard"
}
firewall_policy_rule_collection_group_priority = 100
application_rule_collection                    = []
network_rule_collection = [
  {
    name     = "network-filter-collection"
    action   = "Allow"
    priority = 200
    rule = [
      {
        name                  = "allowhttps-ib-ntc"
        source_addresses      = ["*"]
        destination_ports     = ["443"]
        destination_addresses = ["172.16.1.0/24"] //module to be deployed after spokes are ready
        protocols             = ["TCP"]
      },
      {
        name                  = "allowhttps-ob-ntc"
        source_addresses      = ["172.16.1.0/24"]
        destination_ports     = ["443"]
        destination_addresses = ["*"]
        protocols             = ["TCP"]
    }]
  }
]
nat_rule_collection = [
  {
    name     = "nat-rule-collection"
    action   = "Dnat"
    priority = 100
    rule = [
      {
        name               = "allowrdp-ib-nc"
        description        = "allowrdp-ib-nc"
        protocols          = ["TCP"]
        source_addresses   = ["*"]
        destination_ports  = ["3389"]
        translated_address = "172.16.1.4"
        translated_port    = "3389"
      },
      {
        name               = "allowhttp-ib-nc"
        description        = "allowhttp-ib-nc"
        protocols          = ["TCP"]
        source_addresses   = ["*"]
        destination_ports  = ["8080"]
        translated_address = "172.16.1.4"
        translated_port    = "8080"
      }
    ]
  }
]
use_for_each  = true
address_space = ["172.16.0.0/16"]
subnet_map = {
  "subnet1" = {
    subnet_prefixes                                       = ["172.16.1.0/24"]
    subnet_enforce_private_link_service_network_policies  = false
    subnet_enforce_private_link_endpoint_network_policies = false
    subnet_service_endpoints                              = []
    subnet_delegation                                     = {}
    route_table = { routes = [{
      name                   = "routeToHubFw"
      address_prefix         = "0.0.0.0/0"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.0.1.4" // hub firewall private IP
    }] }
    network_security_group = {
      security_rules = [
        {
          name                         = "AllowRdpInbound"
          access                       = "Allow"
          priority                     = 100
          direction                    = "Inbound"
          protocol                     = "Tcp"
          description                  = "Allow RDP inbound traffic"
          source_port_range            = 3389
          destination_port_range       = 3389
          source_address_prefix        = "*"               // any source
          destination_address_prefixes = ["172.16.1.0/24"] // spoke-resources subnet prefix
        },
        {
          name                         = "AllowHttpInbound"
          access                       = "Allow"
          priority                     = 101
          direction                    = "Inbound"
          protocol                     = "Tcp"
          description                  = "Allow HTTP inbound traffic"
          source_port_ranges           = [443]
          destination_port_ranges      = [443]
          source_address_prefix        = "*"               // any source
          destination_address_prefixes = ["172.16.1.0/24"] // spoke-resources subnet prefix
        }
      ]
    }
  }
}
