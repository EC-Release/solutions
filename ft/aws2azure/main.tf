provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

provider "azurerm" {
  version = "=2.20.0"
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "RG-ram"
  location = "East US"
}

resource "azurerm_virtual_network" "example" {
  name                = "vnet-ram"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_network_security_group" "example" {
  name                = "acceptanceTestSecurityGroup1"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }
}

resource "azurerm_subnet" "example" {
  name                 = "subnet-ram"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes      = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "example" {
  name                    = "publicip-ram"
  location                = azurerm_resource_group.example.location
  resource_group_name     = azurerm_resource_group.example.name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30

  tags = {
    environment = "test"
  }
}

resource "azurerm_network_interface" "example" {
  name                = "nic-ram"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "ramconfiguration1"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.2.5"
    public_ip_address_id          = azurerm_public_ip.example.id
  }
}

resource "azurerm_virtual_machine" "example" {
  name                  = "ram-vm"
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.example.id]
  vm_size               = "Standard_D2s_v3"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "asrikar"
    admin_password = "Sairam81!@#$"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }

//  os_profile_secrets {

//  }
  tags = {
    "Name" = "EC-File-Transfer"
	"UAI" = "UAI3023216"
	"Engineer.SSO" = "212602085"
	"Engineer.Email" = "RamaRao.Srikakulapu@ge.com"
	"Env" = "Dev"
  }
}

//data "azurerm_public_ip" "example" {
//  name                = azurerm_public_ip.example.name
//  resource_group_name = azurerm_virtual_machine.example.resource_group_name
//}

resource "aws_instance" "dc-sandbox-vpc-vm1" {
  ami                         = var.dc-sandbox-vpc-vm.ami
  instance_type               = var.dc-sandbox-vpc-vm.instance_type
  subnet_id                   = var.dc-sandbox-vpc-vm.subnet_id
  security_groups             = var.dc-sandbox-vpc-vm.security_groups
  key_name                    = var.dc-sandbox-vpc-vm.key_name
  iam_instance_profile        = var.dc-sandbox-vpc-vm.iam_instance_profile
  associate_public_ip_address = var.dc-sandbox-vpc-vm.associate_public_ip_address
  user_data                   = <<-EOF
            #! /bin/bash
            sudo su -
            yum update -y >> ~/logs.txt
            yum install httpd -y >> ~/logs.txt
            service httpd start >> ~/logs.txt
            chkconfig httpd on >> ~/logs.txt
            cd /var/www/html >> ~/logs.txt
            echo "<html><h1>test webpage</h1></html>" > index.html
            ${var.dc-sandbox-vpc-vm.scp_command}
   EOF

  root_block_device {
    encrypted = true
  }

  tags = {
    Name           = var.dc-sandbox-vpc-vm.tags.Name
    Env            = var.dc-sandbox-vpc-vm.tags.Env
    Engineer_Email = var.dc-sandbox-vpc-vm.tags.Engineer_Email
    Engineer_SSO   = var.dc-sandbox-vpc-vm.tags.Engineer_SSO
    Best_By        = var.dc-sandbox-vpc-vm.tags.Best_By
    UAI            = var.dc-sandbox-vpc-vm.tags.UAI
    Builder        = var.dc-sandbox-vpc-vm.tags.Builder
  }
}