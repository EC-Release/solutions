provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

provider "azurerm" {
  version = "=2.20.0"
  features {}
}

resource "aws_instance" "aws-dc-sandbox-vpc-vm1" {
  ami                         = var.aws-dc-sandbox-vpc-vm.ami
  instance_type               = var.aws-dc-sandbox-vpc-vm.instance_type
  subnet_id                   = var.aws-dc-sandbox-vpc-vm.subnet_id
  security_groups             = var.aws-dc-sandbox-vpc-vm.security_groups
  key_name                    = var.aws-dc-sandbox-vpc-vm.key_name
  iam_instance_profile        = var.aws-dc-sandbox-vpc-vm.iam_instance_profile
  associate_public_ip_address = var.aws-dc-sandbox-vpc-vm.associate_public_ip_address
  user_data                   = <<-EOF
            #! /bin/bash
            sudo su -
            yum update -y >> ~/logs.txt
            yum install httpd -y >> ~/logs.txt
            service httpd start >> ~/logs.txt
            chkconfig httpd on >> ~/logs.txt
            cd /var/www/html >> ~/logs.txt
            echo "<html><h1>test webpage</h1></html>" > index.html
            ${var.aws-dc-sandbox-vpc-vm.scp_command}
   EOF

  root_block_device {
    encrypted = true
  }

  tags = {
    Name           = var.aws-dc-sandbox-vpc-vm.tags.Name
    Env            = var.aws-dc-sandbox-vpc-vm.tags.Env
    Engineer_Email = var.aws-dc-sandbox-vpc-vm.tags.Engineer_Email
    Engineer_SSO   = var.aws-dc-sandbox-vpc-vm.tags.Engineer_SSO
    Best_By        = var.aws-dc-sandbox-vpc-vm.tags.Best_By
    UAI            = var.aws-dc-sandbox-vpc-vm.tags.UAI
    Builder        = var.aws-dc-sandbox-vpc-vm.tags.Builder
  }
}

resource "azurerm_network_interface" "azure-corp-ec-ft-nic" {
  name                = var.azure-corp-ec-ft-nic.name
  location            = var.azure-corp-ec-ft-nic.location
  resource_group_name = var.azure-corp-ec-ft-nic.resource_group_name

  ip_configuration {
    name                          = var.azure-corp-ec-ft-nic.ip_configuration.name
    subnet_id                     = var.azure-corp-ec-ft-nic.ip_configuration.subnet_id
    private_ip_address_allocation = var.azure-corp-ec-ft-nic.ip_configuration.private_ip_address_allocation
    # Enable this when public ip allowed in corp subscription
    # public_ip_address_id          = azurerm_public_ip.ec-vm-publicip.id
  }
}

resource "azurerm_virtual_machine" "azure-corp-ec-vm" {
  name                  = var.azure-corp-ec-vm.name
  location              = var.azure-corp-ec-vm.location
  resource_group_name   = var.azure-corp-ec-vm.resource_group_name
  network_interface_ids = [azurerm_network_interface.azure-corp-ec-ft-nic.id]
  vm_size               = var.azure-corp-ec-vm.vm_size

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination     = var.azure-corp-ec-vm.delete_os_disk_on_termination

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination  = var.azure-corp-ec-vm.delete_data_disks_on_termination

  storage_image_reference {
    publisher         = var.azure-corp-ec-vm.storage_image_reference.publisher
    offer             = var.azure-corp-ec-vm.storage_image_reference.offer
    sku               = var.azure-corp-ec-vm.storage_image_reference.sku
    version           = var.azure-corp-ec-vm.storage_image_reference.version
  }
  storage_os_disk {
    name              = var.azure-corp-ec-vm.storage_os_disk.name
    caching           = var.azure-corp-ec-vm.storage_os_disk.caching
    create_option     = var.azure-corp-ec-vm.storage_os_disk.create_option
    managed_disk_type = var.azure-corp-ec-vm.storage_os_disk.managed_disk_type
  }
  os_profile {
    computer_name     = var.azure-corp-ec-vm.os_profile.computer_name
    admin_username    = var.azure-corp-ec-vm.os_profile.admin_username
    admin_password    = var.azure-corp-ec-vm.os_profile.admin_password
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    Name           = var.azure-corp-ec-vm.tags.Name
    Env            = var.azure-corp-ec-vm.tags.Env
    Engineer_Email = var.azure-corp-ec-vm.tags.Engineer_Email
    Engineer_SSO   = var.azure-corp-ec-vm.tags.Engineer_SSO
    Best_By        = var.azure-corp-ec-vm.tags.Best_By
    UAI            = var.azure-corp-ec-vm.tags.UAI
    Builder        = var.azure-corp-ec-vm.tags.Builder
  }
}

// Uncomment below section when corp subscription allowed public ip
//resource "azurerm_public_ip" "ec-vm-publicip" {
//  name                    = "publicip-ram"
//  location                = "eastus"
//  resource_group_name     = "cs-connectedVNET"
//  allocation_method       = "Dynamic"
//  idle_timeout_in_minutes = 30
//
//  tags = {
//    environment = "test"
//  }
//}
//
//data "azurerm_public_ip" "example" {
//  name                = azurerm_public_ip.ec-vm-publicip.name
//  resource_group_name = azurerm_virtual_machine.main.resource_group_name
//}