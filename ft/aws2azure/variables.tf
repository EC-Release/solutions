variable "aws_profile" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "aws-dc-sandbox-vpc-ec-gw-server-vm" {
  type = object({
    ami                         = string
    instance_type               = string
    subnet_id                   = string
    security_groups             = list(string)
    key_name                    = string
    iam_instance_profile        = string
    associate_public_ip_address = bool
    ec-sftp-user-name           = string
    ec-sftp-user-secret         = string
    tags                        = map(string)

    ec_gwserver_mod             = string
    ec_gwserver_zon             = string
    ec_gwserver_sst             = string
    ec_gwserver_hst             = string
    ec_gwserver_aid             = string
    ec_gwserver_grp             = string
    ec_gwserver_cid             = string
    ec_gwserver_csc             = string
    ec_gwserver_dur             = number
    ec_gwserver_oa2             = string
    ec_gwserver_rht             = string
    ec_gwserver_rpt             = number
    ec_gwserver_gpt             = string
    ec_gwserver_tkn             = string
    ec_gwserver_dbg             = bool
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

    ecconfig_mod                      = string
    ecconfig_aid                      = string
    ecconfig_tid                      = string
    ecconfig_grp                      = string
    ecconfig_cid                      = string
    ecconfig_csc                      = string
    ecconfig_dur                      = number
    ecconfig_oa2                      = string
    ecconfig_hst                      = string
    ecconfig_lpt                      = number

    storage_image_reference           = map(string)
    storage_os_disk                   = map(string)
    os_profile                        = map(string)
    os_profile_linux_config           = map(string)
    tags                              = map(string)
  })
}