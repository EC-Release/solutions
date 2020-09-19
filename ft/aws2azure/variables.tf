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
    ec-sftp-user-name           = string
    ec-sftp-user-secret         = string
    tags                        = map(string)

    gwserver_mod                = string
    gwserver_zon                = string
    gwserver_sst                = string
    # Following properties needed only when agent running in gw:server mode. It will be enabled once public vm created in azure
    # gwserver_tkn                = string
    # gwserver_gpt                = number
    gwserver_hst                = string
    gwserver_aid                = string
    gwserver_grp                = string
    gwserver_cid                = string
    gwserver_csc                = string
    gwserver_dur                = number
    gwserver_oa2                = string
    gwserver_rht                = string
    gwserver_rpt                = number
    gwserver_dbg                = bool
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