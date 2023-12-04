# Create a resource group
resource "azurerm_resource_group" "lab_xp" {
  name     = "LABORATORIOXP"
  location = var.location_us
}

resource "random_id" "random_id" {
  keepers = {
    # Gere um novo ID a cada mudança de grupo de recursos
    resource_group = azurerm_resource_group.lab_xp.name
  }

  byte_length = 8
}

# Create a virtual network in US East
resource "azurerm_virtual_network" "vnet01" {
  name                = "VNET01"
  address_space       = var.address_space_vnet01
  location            = var.location_us
  resource_group_name = azurerm_resource_group.lab_xp.name
}

# Create a subnet for VNET01
resource "azurerm_subnet" "vnet01_subnet" {
  name                 = "VNET01Subnet"
  resource_group_name  = azurerm_resource_group.lab_xp.name
  virtual_network_name = azurerm_virtual_network.vnet01.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create a virtual network in Brazil South
resource "azurerm_virtual_network" "vnet02" {
  name                = "VNET02"
  address_space       = var.address_space_vnet02
  location            = var.location_brazil
  resource_group_name = azurerm_resource_group.lab_xp.name
}

# Create a subnet for VNET02
resource "azurerm_subnet" "vnet02_subnet" {
  name                 = "VNET02Subnet"
  resource_group_name  = azurerm_resource_group.lab_xp.name
  virtual_network_name = azurerm_virtual_network.vnet02.name
  address_prefixes     = ["10.1.1.0/24"]
}

# Create public IP for machine01
resource "azurerm_public_ip" "machine01_ip" {
  name                = "machine01-ip"
  location            = var.location_us
  resource_group_name = azurerm_resource_group.lab_xp.name
  allocation_method   = "Static"
}

# Create public IP for machine02
resource "azurerm_public_ip" "machine02_ip" {
  name                = "machine02-ip"
  location            = var.location_brazil
  resource_group_name = azurerm_resource_group.lab_xp.name
  allocation_method   = "Static"
}

# Create network security group for machine01
resource "azurerm_network_security_group" "machine01_nsg" {
  name                = "machine01-nsg"
  location            = var.location_us
  resource_group_name = azurerm_resource_group.lab_xp.name
  security_rule {
    name                       = "RDPAccess"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"  # Ajuste conforme necessário para restringir o acesso
    destination_address_prefix = "*"
  }
}

# Create network security group for machine02
resource "azurerm_network_security_group" "machine02_nsg" {
  name                = "machine02-nsg"
  location            = var.location_brazil
  resource_group_name = azurerm_resource_group.lab_xp.name
  security_rule {
    name                       = "RDPAccess"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"  # Ajuste conforme necessário para restringir o acesso
    destination_address_prefix = "*"
  }
}

# Create network interface for machine01
resource "azurerm_network_interface" "machine01_nic" {
  name                = "machine01-nic"
  location            = var.location_us
  resource_group_name = azurerm_resource_group.lab_xp.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.vnet01_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.machine01_ip.id
  }
}

# Create network interface for machine02
resource "azurerm_network_interface" "machine02_nic" {
  name                = "machine02-nic"
  location            = var.location_brazil
  resource_group_name = azurerm_resource_group.lab_xp.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.vnet02_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.machine02_ip.id
  }
}

# Create Windows virtual machine machine01
resource "azurerm_windows_virtual_machine" "machine01" {
  name                = "machine01"
  resource_group_name = azurerm_resource_group.lab_xp.name
  location            = var.location_us
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [azurerm_network_interface.machine01_nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

   source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "windows-11"
    sku       = "win11-21h2-pro"
    version   = "latest"
  }

   # Configuração de Spot
  priority = "Spot"
  eviction_policy = "Deallocate"
  max_bid_price = -1  # -1 significa que você está disposto a pagar até o preço padrão da VM

}

# Create Windows virtual machine machine02
resource "azurerm_windows_virtual_machine" "machine02" {
  name                = "machine02"
  resource_group_name = azurerm_resource_group.lab_xp.name
  location            = var.location_brazil
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [azurerm_network_interface.machine02_nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "windows-11"
    sku       = "win11-21h2-pro"
    version   = "latest"
  }

   # Configuração de Spot
  priority = "Spot"
  eviction_policy = "Deallocate"
  max_bid_price = -1  # -1 significa que você está disposto a pagar até o preço padrão da VM

}

# Create managed disk for machine01
resource "azurerm_managed_disk" "machine01_disk1" {
  name                 = "machine01_disk1"
  location             = var.location_us
  resource_group_name  = azurerm_resource_group.lab_xp.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.managed_disk_size_gb
}

# Create managed disk for machine02
resource "azurerm_managed_disk" "machine02_disk1" {
  name                 = "machine02_disk1"
  location             = var.location_brazil
  resource_group_name  = azurerm_resource_group.lab_xp.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.managed_disk_size_gb
}

# Attach managed disk to virtual machine machine01
resource "azurerm_virtual_machine_data_disk_attachment" "machine01_disk_attachment" {
  managed_disk_id    = azurerm_managed_disk.machine01_disk1.id
  virtual_machine_id = azurerm_windows_virtual_machine.machine01.id
  lun                = 0
  caching            = "ReadWrite"
}

# Attach managed disk to virtual machine machine02
resource "azurerm_virtual_machine_data_disk_attachment" "machine02_disk_attachment" {
  managed_disk_id    = azurerm_managed_disk.machine02_disk1.id
  virtual_machine_id = azurerm_windows_virtual_machine.machine02.id
  lun                = 0
  caching            = "ReadWrite"
}

# Connect the security group to the network interface for machine01
resource "azurerm_network_interface_security_group_association" "machine01_nsg_association" {
  network_interface_id      = azurerm_network_interface.machine01_nic.id
  network_security_group_id = azurerm_network_security_group.machine01_nsg.id
}

# Connect the security group to the network interface for machine02
resource "azurerm_network_interface_security_group_association" "machine02_nsg_association" {
  network_interface_id      = azurerm_network_interface.machine02_nic.id
  network_security_group_id = azurerm_network_security_group.machine02_nsg.id
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "my_storage_account" {
  name                     = "diag${random_id.random_id.hex}"
  location                 = var.location_us
  resource_group_name      = azurerm_resource_group.lab_xp.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Peering from VNET01 to VNET02
resource "azurerm_virtual_network_peering" "vnet01_to_vnet02" {
  name                      = "vnet01-to-vnet02"
  resource_group_name       = azurerm_resource_group.lab_xp.name
  virtual_network_name      = azurerm_virtual_network.vnet01.name
  remote_virtual_network_id = azurerm_virtual_network.vnet02.id
  allow_virtual_network_access = true
}

# Peering from VNET02 to VNET01
resource "azurerm_virtual_network_peering" "vnet02_to_vnet01" {
  name                      = "vnet02-to-vnet01"
  resource_group_name       = azurerm_resource_group.lab_xp.name
  virtual_network_name      = azurerm_virtual_network.vnet02.name
  remote_virtual_network_id = azurerm_virtual_network.vnet01.id
  allow_virtual_network_access = true
}
