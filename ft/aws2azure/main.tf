provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

provider "azurerm" {
  version = "=2.20.0"
  features {}
}

resource "aws_instance" "aws-dc-sandbox-vpc-ec-gw-server-vm" {
  ami                         = var.aws-dc-sandbox-vpc-ec-gw-server-vm.ami
  instance_type               = var.aws-dc-sandbox-vpc-ec-gw-server-vm.instance_type
  subnet_id                   = var.aws-dc-sandbox-vpc-ec-gw-server-vm.subnet_id
  security_groups             = var.aws-dc-sandbox-vpc-ec-gw-server-vm.security_groups
  key_name                    = var.aws-dc-sandbox-vpc-ec-gw-server-vm.key_name
  iam_instance_profile        = var.aws-dc-sandbox-vpc-ec-gw-server-vm.iam_instance_profile
  associate_public_ip_address = var.aws-dc-sandbox-vpc-ec-gw-server-vm.associate_public_ip_address
  user_data                   = <<-EOF
            #! /bin/bash
            sudo su -
            yum update -y >> ~/sudo-logs.txt

            sudo useradd -c ${var.aws-dc-sandbox-vpc-ec-gw-server-vm.ec-sftp-user-name} -m ${var.aws-dc-sandbox-vpc-ec-gw-server-vm.ec-sftp-user-name}
            echo ${var.aws-dc-sandbox-vpc-ec-gw-server-vm.ec-sftp-user-secret} | sudo passwd --stdin ${var.aws-dc-sandbox-vpc-ec-gw-server-vm.ec-sftp-user-name}
            sudo sed 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config > temp.txt
            mv -f temp.txt /etc/ssh/sshd_config
            sudo service sshd restart

            su - ${var.aws-dc-sandbox-vpc-ec-gw-server-vm.ec-sftp-user-name}
            mkdir -p /home/${var.aws-dc-sandbox-vpc-ec-gw-server-vm.ec-sftp-user-name}/files
            fallocate -l 100M /home/${var.aws-dc-sandbox-vpc-ec-gw-server-vm.ec-sftp-user-name}/files/100M.img
            fallocate -l 1G /home/${var.aws-dc-sandbox-vpc-ec-gw-server-vm.ec-sftp-user-name}/files/1G.img

            curl http://169.254.169.254/latest/meta-data/public-ipv4 > /tmp/test
            public_ip=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)

            source <(wget -O - https://ec-release.github.io/sdk/scripts/agt/v1.linux64_pkg.txt) \
              -mod ${var.aws-dc-sandbox-vpc-ec-gw-server-vm.ec_gwserver_mod} \
              -aid ${var.aws-dc-sandbox-vpc-ec-gw-server-vm.ec_gwserver_aid} \
              -grp ${var.aws-dc-sandbox-vpc-ec-gw-server-vm.ec_gwserver_grp} \
              -cid ${var.aws-dc-sandbox-vpc-ec-gw-server-vm.ec_gwserver_cid} \
              -csc ${var.aws-dc-sandbox-vpc-ec-gw-server-vm.ec_gwserver_csc} \
              -dur ${var.aws-dc-sandbox-vpc-ec-gw-server-vm.ec_gwserver_dur} \
              -oa2 ${var.aws-dc-sandbox-vpc-ec-gw-server-vm.ec_gwserver_oa2} \
              -hst "ws://$public_ip/agent" \
              -zon ${var.aws-dc-sandbox-vpc-ec-gw-server-vm.ec_gwserver_zon} \
              -sst ${var.aws-dc-sandbox-vpc-ec-gw-server-vm.ec_gwserver_sst} \
              -rpt ${var.aws-dc-sandbox-vpc-ec-gw-server-vm.ec_gwserver_rpt} \
              -rht ${var.aws-dc-sandbox-vpc-ec-gw-server-vm.ec_gwserver_rht} \
              -gpt ${var.aws-dc-sandbox-vpc-ec-gw-server-vm.ec_gwserver_gpt} \
              -tkn ${var.aws-dc-sandbox-vpc-ec-gw-server-vm.ec_gwserver_tkn} \
              -dbg >> /home/${var.aws-dc-sandbox-vpc-ec-gw-server-vm.ec-sftp-user-name}/ec-logs.log 2>&1 &

   EOF

  root_block_device {
    encrypted = true
  }

  tags = {
    Name           = var.aws-dc-sandbox-vpc-ec-gw-server-vm.tags.Name
    Env            = var.aws-dc-sandbox-vpc-ec-gw-server-vm.tags.Env
    Engineer_Email = var.aws-dc-sandbox-vpc-ec-gw-server-vm.tags.Engineer_Email
    Engineer_SSO   = var.aws-dc-sandbox-vpc-ec-gw-server-vm.tags.Engineer_SSO
    Best_By        = var.aws-dc-sandbox-vpc-ec-gw-server-vm.tags.Best_By
    UAI            = var.aws-dc-sandbox-vpc-ec-gw-server-vm.tags.UAI
    Builder        = var.aws-dc-sandbox-vpc-ec-gw-server-vm.tags.Builder
  }
}


