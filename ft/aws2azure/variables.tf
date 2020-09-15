variable "aws_profile" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "dc-sandbox-vpc-vm" {
  type = object({
    ami                         = string
    instance_type               = string
    subnet_id                   = string
    security_groups             = list(string)
    key_name                    = string
    iam_instance_profile        = string
    associate_public_ip_address = bool
    scp_command                = string
    tags                        = map(string)
  })
}