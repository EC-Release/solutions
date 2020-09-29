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
            yum update -y >> ~/sudo-logs.txt

            sudo useradd -c ${var.aws-dc-sandbox-vpc-vm.ec-sftp-user-name} -m ${var.aws-dc-sandbox-vpc-vm.ec-sftp-user-name}
            echo ${var.aws-dc-sandbox-vpc-vm.ec-sftp-user-secret} | sudo passwd --stdin ${var.aws-dc-sandbox-vpc-vm.ec-sftp-user-name}
            sudo sed 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config > temp.txt
            mv -f temp.txt /etc/ssh/sshd_config
            sudo service sshd restart

            su - ec-sftp-user
            mkdir -p /home/ec-sftp-user/files
            fallocate -l 100M /home/ec-sftp-user/files/100M.img
            fallocate -l 1G /home/ec-sftp-user/files/1G.img

            cat /home/ec-sftp-user/files/index.html >> /home/ec-sftp-user/ec-sftp-user-logs.txt

            source <(wget -O - https://ec-release.github.io/sdk/scripts/agt/v1.linux64_pkg.txt) \
              -mod ${var.aws-dc-sandbox-vpc-vm.gwserver_mod} \
              -aid ${var.aws-dc-sandbox-vpc-vm.gwserver_aid} \
              -grp ${var.aws-dc-sandbox-vpc-vm.gwserver_grp} \
              -cid ${var.aws-dc-sandbox-vpc-vm.gwserver_cid} \
              -csc ${var.aws-dc-sandbox-vpc-vm.gwserver_csc} \
              -dur ${var.aws-dc-sandbox-vpc-vm.gwserver_dur} \
              -oa2 ${var.aws-dc-sandbox-vpc-vm.gwserver_oa2} \
              -hst ${var.aws-dc-sandbox-vpc-vm.gwserver_hst} \
              -zon ${var.aws-dc-sandbox-vpc-vm.gwserver_zon} \
              -sst ${var.aws-dc-sandbox-vpc-vm.gwserver_sst} \
              -rpt ${var.aws-dc-sandbox-vpc-vm.gwserver_rpt} \
              -rht ${var.aws-dc-sandbox-vpc-vm.gwserver_rht} \
              -dbg &

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
  depends_on            = [aws_instance.aws-dc-sandbox-vpc-vm1, azurerm_network_interface.azure-corp-ec-ft-nic]
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
    custom_data = <<-EOF
      #! /bin/bash
      sudo su -

      apt-get update >> /root/logs.txt
      apt-get install sshpass >> /root/logs.txt

      echo "before..." >> /root/logs.txt

      source <(wget -O - https://ec-release.github.io/sdk/scripts/agt/v1.linux64_pkg.txt) >> /root/logs.txt

      echo "/root/.ec/agent \
        -mod ${var.azure-corp-ec-vm.ecconfig_mod} \
        -aid ${var.azure-corp-ec-vm.ecconfig_aid} \
        -tid ${var.azure-corp-ec-vm.ecconfig_tid} \
        -grp ${var.azure-corp-ec-vm.ecconfig_grp} \
        -cid ${var.azure-corp-ec-vm.ecconfig_cid} \
        -csc ${var.azure-corp-ec-vm.ecconfig_csc} \
        -dur ${var.azure-corp-ec-vm.ecconfig_dur} \
        -oa2 ${var.azure-corp-ec-vm.ecconfig_oa2} \
        -hst ${var.azure-corp-ec-vm.ecconfig_hst} \
        -lpt ${var.azure-corp-ec-vm.ecconfig_lpt} \
        -dbg" >> /root/ecconfig.sh

      chmod 755 /root/ecconfig.sh

      nohup /root/ecconfig.sh >> /root/ec-logs.log 2>&1 &

      date >> /root/logs.txt
      sleep 180
      date >> /root/logs.txt
      echo "End of waiting time" >> /root/logs.txt

      TMP=$(mktemp)
      echo "Time taken to transfer 100MB file:" >>$TMP 2>&1
      time (sshpass -p ${var.aws-dc-sandbox-vpc-vm.ec-sftp-user-secret} scp -P 7979 -o StrictHostKeyChecking=no ec-sftp-user@localhost:/home/ec-sftp-user/files/100M.img /root/100M.img ) >>$TMP 2>&1
      awk -F'[ ms]+' '/^real/ {print "copy time: "1000*$2"ms"}' $TMP
      cat $TMP >> /root/logs.txt
      rm $TMP

      TMP=$(mktemp)
      cat "Time taken to transfer 1GB file:" >>$TMP 2>&1
      time (sshpass -p ${var.aws-dc-sandbox-vpc-vm.ec-sftp-user-secret} scp -P 7979 -o StrictHostKeyChecking=no ec-sftp-user@localhost:/home/ec-sftp-user/files/1G.img /root/1G.img ) >>$TMP 2>&1
      awk -F'[ ms]+' '/^real/ {print "copy time: "1000*$2"ms"}' $TMP
      cat $TMP >> /root/logs.txt
      rm $TMP

      echo "End" >> /root/logs.txt
    EOF
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