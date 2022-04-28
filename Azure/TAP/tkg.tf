resource "azurerm_resource_group" "rg" {
  name     = "${local.resource_group.rg1.name}"
  location = "${local.location.region}"
}

resource "azurerm_network_security_group" "nsg-ctrl" {
  name                = "${local.cluster.name}-controlplane-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "bootstrap" {
  name                        = "TEMPORARY-ALLOW-ALL"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg-ctrl.name
}

resource "azurerm_network_security_group" "nsg-node" {
  name                = "${local.cluster.name}-node-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_virtual_network" "vnet-tkg" {
  name                = "vnet-tkg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "ctrl" {
  name           = "subnet-ctrl"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet-tkg.name
  address_prefixes = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "node" {
  name           = "subnet-node"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet-tkg.name
  address_prefixes = ["10.0.1.0/24"]
}

resource "azurerm_subnet_network_security_group_association" "ctrl" {
  subnet_id                 = azurerm_subnet.ctrl.id
  network_security_group_id = azurerm_network_security_group.nsg-ctrl.id
}

resource "azurerm_subnet_network_security_group_association" "node" {
  subnet_id                 = azurerm_subnet.node.id
  network_security_group_id = azurerm_network_security_group.nsg-node.id
}
