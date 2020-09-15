variable "aws_profile" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "aws-dc-sandbox-vpc-vm" {
  type = object({
    ami                         = string
    instance_type               = string
    subnet_id                   = string
    security_groups             = list(string)
    key_name                    = string
    iam_instance_profile        = string
    associate_public_ip_address = bool
    scp_command                 = string
    tags                        = map(string)
  })
}

variable "azure-corp-ec-ft-nic" {
  type = object({
    name                = string
    location            = string
    resource_group_name = string
    ip_configuration    = map(string)
  })
}

variable "azure-corp-ec-vm" {
  type = object({
    name                              = string
    location                          = string
    resource_group_name               = string
    network_interface_ids             = list(string)
    vm_size                           = string
    delete_os_disk_on_termination     = bool
    delete_data_disks_on_termination  = bool

    storage_image_reference           = map(string)
    storage_os_disk                   = map(string)
    os_profile                        = map(string)
    os_profile_linux_config           = map(string)
    tags                              = map(string)
  })
}