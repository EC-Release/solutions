provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

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