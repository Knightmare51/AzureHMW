resource "azurerm_virtual_machine" "${var.default_tags.env}e" {
  name                  = "${var.default_tags.env}e-vm"
  location              = azurerm_resource_group.${var.default_tags.env}e.location
  resource_group_name   = azurerm_resource_group.${var.default_tags.env}e.name
  network_interface_ids = [azurerm_network_interface.${var.default_tags.env}e.id]
  vm_size               = "Standard_F2"

  storage_os_disk {
    name              = "myosdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "hostname"
    admin_username = "adminuser"
    admin_password = "Password123!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}