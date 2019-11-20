
# region
variable "region" {
  default     = "eu-central-1"
  description = "The region to use for this module."
}

# vpc
variable "vpc_name" {
  description = "The name of the VPC. Other names will result from this."
  default     = "my-vpc"
}

variable "vpc_network" {
  default     = "10.0.0.0/24"
  description = "Network within which the Subnets will be created."
}

# subnets
variable "sn_private_a_name" {
  description = "The name of the 1st Public Subnet which will be available in AZ-a."
  default     = "Private A"
}

variable "sn_private_b_name" {
  description = "The name of the 2nd Private Subnet which will be available in AZ-b."
  default     = "Private B"
}

variable "sn_private_c_name" {
  description = "The name of the 3rd Private Subnet which will be available in AZ-c."
  default     = "Private C"
}

// variable "sn_private_d_name" {
//   description = "The name of the 4th Private Subnet which will be available in AZ-d."
//   default     = "Private d"
// }

variable "sn_public_a_name" {
  description = "The name of the 1st Public Subnet which will be available in AZ-a."
  default     = "Public A"
}

variable "sn_public_b_name" {
  description = "The name of the 2nd Public Subnet which will be available in AZ-b."
  default     = "Public B"
}

variable "sn_public_c_name" {
  description = "The name of the 3rd Public Subnet which will be available in AZ-c."
  default     = "Public C"
}

// variable "sn_public_d_name" {
//   description = "The name of the 4th Public Subnet which will be available in AZ-d."
//   default     = "Public d"
// }

# network resources
variable "enable_dns_hostnames" {
  default     = true
  description = " (Optional) A boolean flag to enable/disable DNS hostnames in the VPC"
}
variable "create_igw" {
  description = "Create Internet GW for public subnets if set to true"
  default     = false
}

variable "create_nat" {
  description = "Create NAT GW for private subnets if set to true"
  default     = false
}

# DHCP
variable "create_dhcp" {
  default = false
}
variable "vpc_dhcp_options_tag_name" {
  default = "tf-dopt"
}

variable "domain_name" {
  default = null
}

variable "domain_name_servers" {
  default = null
  type    = "list"
}

variable "ntp_servers" {
  default = null
  type    = "list"
}

variable "netbios_name_servers" {
  default = null
  type    = "list"
}

variable "netbios_node_type" {
  default = null
}

# network acl
variable "create_network_acl" {
  default = false
}

variable "network_acl_tag_name" {
  default = "tf-vpc-network"
}

variable "network_acl_rules" {
  type = list(object({
    #network_acl_id = string
    rule_number = number
    egress      = bool
    protocol    = string
    rule_action = string
    cidr_block  = string
    from_port   = number
    to_port     = number
  }))
  default = null

}

# transit gateway attachment
variable "share_arn" {
  description = "The resource access manager share ARN which contains the transit gateway resource"
  default     = null
}

variable "create_tgw_attachment" {
  default = false
}

variable "transit_gateway_id" {
  default = null
}

variable "tgw_attachment_tag_name" {
  default = "my-company-network"
}

variable "tgw_destination_cidr_block" {
  default = null
}
