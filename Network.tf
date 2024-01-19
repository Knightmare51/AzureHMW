terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "${var.default_tags.env}e" {
  name     = "${var.default_tags.env}-resources"
  location = "East US"
}

resource "azurerm_virtual_network" "${var.default_tags.env}e" {
  name                = "${var.default_tags.env}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.${var.default_tags.env}e.location
  resource_group_name = azurerm_resource_group.${var.default_tags.env}e.name
}

resource "azurerm_subnet" "public" {
  name                 = "${var.default_tags.env}-subnet-public"
  resource_group_name  = azurerm_resource_group.${var.default_tags.env}e.name
  virtual_network_name = azurerm_virtual_network.${var.default_tags.env}e.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "private" {
  name                 = "${var.default_tags.env}e-subnet-private"
  resource_group_name  = azurerm_resource_group.${var.default_tags.env}e.name
  virtual_network_name = azurerm_virtual_network.${var.default_tags.env}e.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_security_group" "${var.default_tags.env}e" {
  name                = "${var.default_tags.env}e-nsg"
  location            = azurerm_resource_group.${var.default_tags.env}e.location
  resource_group_name = azurerm_resource_group.${var.default_tags.env}e.name
}

resource "azurerm_network_security_rule" "${var.default_tags.env}e" {
  name                        = "SSH"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.${var.default_tags.env}e.name
  resource_group_name         = azurerm_resource_group.${var.default_tags.env}e.name
}
resource "azurerm_network_interface" "${var.default_tags.env}e" {
  name                = "${var.default_tags.env}e-nic"
  location            = azurerm_resource_group.${var.default_tags.env}e.location
  resource_group_name = azurerm_resource_group.${var.default_tags.env}e.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.public.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.${var.default_tags.env}e.id
  }
}

resource "azurerm_public_ip" "${var.default_tags.env}e" {
  name                = "${var.default_tags.env}e-public-ip"
  location            = azurerm_resource_group.${var.default_tags.env}e.location
  resource_group_name = azurerm_resource_group.${var.default_tags.env}e.name
  allocation_method   = "Static"
}
