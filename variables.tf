
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
  default = "10.0.0.0/24"
  # default     = ""
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

variable "dhcp_domain_name" {
  default = ""
}

variable "domain_name_servers" {
  type    = list(any)
  default = []

}

variable "ntp_servers" {
  type    = list(any)
  default = []
}

variable "netbios_name_servers" {
  type    = list(any)
  default = []
}

variable "netbios_node_type" {
  default = ""
}

# network acl
## entire vpc
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

## private subnets only
variable "create_private_subnet_acl" {
  default = false
}

variable "private_subnet_tag_name" {
  default = "tf-vpc-network-private"
}

variable "private_subnet_acl_rules" {
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

## public subnets only
variable "create_public_subnet_acl" {
  default = false
}

variable "public_subnet_tag_name" {
  default = "tf-vpc-network-public"
}

variable "public_subnet_acl_rules" {
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
variable "accept_resource_share" {
  description = "Does the resource access manager resource share containaing the transit gateway need to be accepted?"
  default     = false
}

variable "share_arn" {
  description = "The resource access manager share ARN which contains the transit gateway resource"
  default     = ""
}

variable "create_tgw_attachment" {
  default = false
}

variable "tgw_attachment_aza_subnet" {
  description = "The private subnet in the availability zone A to be attached to the Transit Gateway"
  default     = -1
}

variable "tgw_attachment_azb_subnet" {
  description = "The private subnet in the availability zone B to be attached to the Transit Gateway"
  default     = -1
}

variable "tgw_attachment_azc_subnet" {
  description = "The private subnet in the availability zone C to be attached to the Transit Gateway"
  default     = -1
}

variable "create_tgw_attachment_without_ram" {
  default = false
}

variable "transit_gateway_id" {
  default = ""
}

variable "tgw_attachment_tag_name" {
  default = "my-company-network"
}

variable "tgw_destination_cidr_blocks" {
  description = "The IP ranges where traffic should be forwarded to the transit gateway"
  type        = list(string)
  default     = []
}

# custom subnet ranges/quantities
variable "private_subnets_a" {
  description = "List of CIDR blocks for private subnets in AZ A"
  type        = list(string)
  default     = []
}

variable "private_subnets_b" {
  description = "List of CIDR blocks for private subnets in AZ B"
  type        = list(string)
  default     = []
}

variable "private_subnets_c" {
  description = "List of CIDR blocks for private subnets in AZ C"
  type        = list(string)
  default     = []
}

variable "public_subnets_a" {
  description = "List of CIDR blocks for public subnets in AZ A"
  type        = list(string)
  default     = []
}

variable "public_subnets_b" {
  description = "List of CIDR blocks for public subnets in AZ B"
  type        = list(string)
  default     = []
}

variable "public_subnets_c" {
  description = "List of CIDR blocks for public subnets in AZ C"
  type        = list(string)
  default     = []
}

# Availability Zones 

variable "az1" {
  description = "Availabilty zone for Subnet A"
  type        = string
  default     = ""
}

variable "az2" {
  description = "Availabilty zone for Subnet B"
  type        = string
  default     = ""
}

variable "az3" {
  description = "Availabilty zone for Subnet C"
  type        = string
  default     = ""
}

# tags
variable "vpc_tags" {
  description = "Tags for the VPC"
  type        = map(string)
  default     = {}
}

variable "sn_private_a_tags" {
  description = "List of maps containing key value tag pairs"
  type        = list(map(string))
  default     = []
}

variable "sn_private_b_tags" {
  description = "List of maps containing key value tag pairs"
  type        = list(map(string))
  default     = []
}

variable "sn_private_c_tags" {
  description = "List of maps containing key value tag pairs"
  type        = list(map(string))
  default     = []
}

variable "sn_public_a_tags" {
  description = "List of maps containing key value tag pairs"
  type        = list(map(string))
  default     = []
}

variable "sn_public_b_tags" {
  description = "List of maps containing key value tag pairs"
  type        = list(map(string))
  default     = []
}

variable "sn_public_c_tags" {
  description = "List of maps containing key value tag pairs"
  type        = list(map(string))
  default     = []
}

variable "nat_gw_tags" {
  description = "Map containing key value tag pairs"
  type        = map(string)
  default     = {}
}

variable "igw_tags" {
  description = "Map containing key value tag pairs"
  type        = map(string)
  default     = {}
}

variable "rt_private_tags" {
  description = "Map containing key value tag pairs"
  type        = map(string)
  default     = {}
}

variable "rt_public_tags" {
  description = "Map containing key value tag pairs"
  type        = map(string)
  default     = {}
}

# VPC Endpoints

variable "create_vpcep_s3" {
  description = "Create VPC endpoint for S3 if set to true"
  default     = false
}

variable "vpcep_s3_tags" {
  description = "Map containing key value tag pairs"
  type        = map(string)
  default     = {}
}

variable "vpcep_s3_name" {
  description = "The name of the S3 endpoint."
  default     = "S3 access"
}

variable "create_vpcep_dynamodb" {
  description = "Create VPC endpoint for DynamoDB if set to true"
  default     = false
}

variable "vpcep_dynamodb_tags" {
  description = "Map containing key value tag pairs"
  type        = map(string)
  default     = {}
}

variable "vpcep_dynamodb_name" {
  description = "The name of the DynamoDB endpoint."
  default     = "DynamoDB access"
}

# Multi-AZ NAT GW

variable "private_subnet_rt_per_az_association" {
  description = "Whether to associate the proper subnets to the RT specific per AZ"
  type        = bool
  default     = false
}

variable "nat_gw_azs" {
  description = "AZ on which the NAT GW's should be deployed. Can be 'a,b', 'a,c' or 'c,b'"
  type        = list(string)
  default     = []
}

# Additional CIDRs to VPC

variable "vpc_additional_cidr" {
  description = "Additional CIDRs for VPC"
  type        = list(string)
  default     = []
}

variable "additional_private_subnets_a" {
  description = "List of CIDR blocks for private subnets in AZ A"
  type        = list(string)
  default     = []
}
variable "additional_private_subnets_b" {
  description = "List of CIDR blocks for private subnets in AZ B"
  type        = list(string)
  default     = []
}
variable "additional_private_subnets_c" {
  description = "List of CIDR blocks for private subnets in AZ C"
  type        = list(string)
  default     = []
}
variable "additional_public_subnets_a" {
  description = "List of CIDR blocks for public subnets in AZ A"
  type        = list(string)
  default     = []
}

variable "additional_public_subnets_b" {
  description = "List of CIDR blocks for public subnets in AZ B"
  type        = list(string)
  default     = []
}
variable "additional_public_subnets_c" {
  description = "List of CIDR blocks for public subnets in AZ C"
  type        = list(string)
  default     = []
}
variable "additional_sn_private_a_name" {
  description = "The name of the 1st Public Subnet which will be available in AZ-a."
  default     = "Private A"
}
variable "additional_sn_private_b_name" {
  description = "The name of the 1st Public Subnet which will be available in AZ-a."
  default     = "Private B"
}
variable "additional_sn_private_c_name" {
  description = "The name of the 1st Public Subnet which will be available in AZ-a."
  default     = "Private C"
}

variable "additional_sn_public_a_name" {
  description = "The name of the 1st Public Subnet which will be available in AZ-a."
  default     = "Public A"
}

variable "additional_sn_public_b_name" {
  description = "The name of the 2nd Public Subnet which will be available in AZ-b."
  default     = "Public B"
}

variable "additional_sn_public_c_name" {
  description = "The name of the 3rd Public Subnet which will be available in AZ-c."
  default     = "Public C"
}
variable "additional_sn_private_a_tags" {
  description = "List of maps containing key value tag pairs"
  type        = list(map(string))
  default     = []
}
variable "additional_sn_private_b_tags" {
  description = "List of maps containing key value tag pairs"
  type        = list(map(string))
  default     = []
}
variable "additional_sn_private_c_tags" {
  description = "List of maps containing key value tag pairs"
  type        = list(map(string))
  default     = []
}
variable "additional_sn_public_a_tags" {
  description = "List of maps containing key value tag pairs"
  type        = list(map(string))
  default     = []
}

variable "additional_sn_public_b_tags" {
  description = "List of maps containing key value tag pairs"
  type        = list(map(string))
  default     = []
}

variable "additional_sn_public_c_tags" {
  description = "List of maps containing key value tag pairs"
  type        = list(map(string))
  default     = []
}

# VPC flow logs

variable "vpc_flow_log_bucket_name" {
  description = "Name of the S3 bucket that will contain the VPC flow logs"
  type        = string
  default     = ""
}

variable "vpc_flow_log_cw_log_group_name" {
  description = "Name of the Cloudwatch log group that will contain the VPC flow logs"
  type        = string
  default     = ""
}

variable "vpc_flow_log_retention_period" {
  description = "Retention period for the VPC flow logs. Applies to both S3 and Cloudwatch logs"
  type        = number
  default     = 30
}

variable "vpc_flow_log_traffic_type" {
  description = "Whether to log accepted flows, rejected flows or both. Default is both"
  type        = string
  default     = "ALL"
}

variable "vpc_flow_log_custom_format" {
  description = "Definition for the VPC log flow format, in case a custom definition is needed"
  type        = string
  default     = ""
}

variable "vpc_flow_log_kms_key_arn" {
  description = "KMS Key ARN to encrypt either the bucket or CW log group to store VPC flow logs. KMS policy must allow access to principal delivery.logs.amazonaws.com or logs.<region>.amazonaws.com, depending the case"
  type        = string
  default     = ""
}

variable "vpc_flow_logs_tags" {
  description = "Tags to add to the VPC flow logs"
  type        = map(string)
  default     = {}
}

variable "vpc_flow_logs_storage_tags" {
  description = "Tags to add to S3 bucket and/or CW log group deployed for the VPC flow logs"
  type        = map(string)
  default     = {}
}