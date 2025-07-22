resource "azurerm_resource_group" "resourcegroup" {
  name     = "vikrant-resources"
  location = "eastasia"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vikrant-network"
  resource_group_name = azurerm_resource_group.resourcegroup.name
  location            = azurerm_resource_group.resourcegroup.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "internal-subnet"
  resource_group_name  = azurerm_resource_group.resourcegroup.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "pip" {
  name                = "frontend-ip"
  resource_group_name = azurerm_resource_group.resourcegroup.name
  location            = azurerm_resource_group.resourcegroup.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "nic" {
  name                = "frontend-nic"
  location            = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                            = "frontend-machine"
  resource_group_name             = azurerm_resource_group.resourcegroup.name
  location                        = azurerm_resource_group.resourcegroup.location
  size                            = "Standard_F2"
  admin_username                  = "adminuser"
  admin_password                  = "Vikrant@141194"
  disable_password_authentication = false

  network_interface_ids = [ azurerm_network_interface.nic.id ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 30
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
