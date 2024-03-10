resource "azurerm_resource_group" "my_rg" {
  name     = "my-ubuntu-rg"
  location = "East US"  # Change this to your desired location
}

resource "azurerm_virtual_network" "my_vnet" {
  name                = "my-ubuntu-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.my_rg.location
  resource_group_name = azurerm_resource_group.my_rg.name
}

resource "azurerm_subnet" "my_subnet" {
  name                 = "my-subnet"
  virtual_network_name = azurerm_virtual_network.my_vnet.name
  resource_group_name  = azurerm_resource_group.my_rg.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "my_public_ip" {
  name                = "my-ubuntu-ip"
  location            = azurerm_resource_group.my_rg.location
  resource_group_name = azurerm_resource_group.my_rg.name
  allocation_method   = "Dynamic"
}

data "azurerm_public_ip" "example" {
  name                = azurerm_public_ip.my_public_ip.name
  resource_group_name = azurerm_linux_virtual_machine.my_vm.resource_group_name
}

resource "azurerm_network_interface" "my_nic" {
  name                = "my-nic"
  location            = azurerm_resource_group.my_rg.location
  resource_group_name = azurerm_resource_group.my_rg.name

  ip_configuration {
    name                          = "my-nic-ipconfig"
    subnet_id                     = azurerm_subnet.my_subnet.id
    private_ip_address_allocation = "Dynamic"  # or "Static" if you want a specific IP
  }
}

resource "azurerm_linux_virtual_machine" "my_vm" {
  name                = "my-ubuntu-vm"
  resource_group_name = azurerm_resource_group.my_rg.name
  location            = azurerm_resource_group.my_rg.location
  size                = "Standard_D2s_v3"  # Choose an appropriate VM size
  disable_password_authentication = false
  admin_username      = "tauqeer"
  admin_password      = "tauqeer@@123"  # Replace with your own password
  network_interface_ids = [azurerm_network_interface.my_nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
}
