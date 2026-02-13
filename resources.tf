resource "azurerm_resource_group" "azrg" {
  name     = var.rgname
  location = var.location
}

resource "azurerm_storage_account" "azsa" {
  name = "azrm storage account"
  resource_group_name = azurerm_resource_group.azrg.name
  location = azurerm_resource_group.azrg.location
  account_tier = "Standard"
  account_replication_type = "LRS"
  lifecycle {
    prevent_destroy = true
    ignore_changes = [ tags ]
  }
}

resource "azurerm_virtual_network" "Vnet" {
  name = "vnet-meta"
  address_space = "10.1.0.0./16"
  resource_group_name = azurerm_resource_group.azrg.name
  location = azurerm_resource_group.azrg.location

}

resource "azurerm_subnet" "subnet" {
  name = "subnet-meta"
  resource_group_name = azurerm_resource_group.azrg.name
  virtual_network_name = azurerm_virtual_network.Vnet.name
  address_prefixes = ["10.1.1.0/24"]

}
resource "azurerm_network_security_group" "nsg" {
  name = "subnet-meta"
  resource_group_name = azurerm_resource_group.azrg.name
  location = azurerm_resource_group.azrg.location
  security_rule = {
    name = "allow_ssh"
    Priority = 300
    direction = "Inbound"
    acces  = "Allow"
    destination_port_range = "22"
    source_port_range = "*"
    protocol = "Tcp"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }

}

resource "azurerm_public_ip" "pip" {
  count = var.Vm_count  #need to add
  name = "pip-meta-${count.index}"
  resource_group_name = azurerm_resource_group.azrg.name
  location = azurerm_resource_group.azrg.location
  allocation_method = "Static"
  
}

resource "azurerm_network_interface" "nic" {
  count = var.Vm_count  #need to add
  name = "pip-meta-${count.index}"
  resource_group_name = azurerm_resource_group.azrg.name
  location = azurerm_resource_group.azrg.location
  ip_configuration {
    name = "ioconfih-meta"
    subnet_id = ""
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.pip[count.index].id
  }
}

resource "azurerm_network_interface_security_group_association" "NIC" {
  count = var.Vm_count  #need to add
  network_interface_id = azurerm_network_interface.nic[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_linux_virtual_machine" "linux_vm" {
  count = var.Vm_count  #need to add
  name = "meta_vm-${count.index}"
  resource_group_name = azurerm_resource_group.azrg.name
  location = azurerm_resource_group.azrg.location
  size = var.Vm_size
  network_interface_ids = [azurerm_network_interface.nic[count.index].id]
  os_disk {
    name = "osdisk-${count.index}"
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
    
    }
  admin_username = var.admin_user
  admin_ssh_key {
    username = var.admin_user.username
    public_key = file(var.ssh_public_key_path)
  }
  disable_password_authentication = true
  source_image_reference {
    publisher = "canonical"
    offer = "ubuntu-24_04_lts"
    sku = "server"
    version = "latest"

  }
  depends_on = [ azurerm_storage_account.azsa ]
}
