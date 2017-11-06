data "aws_caller_identity" "current" {}

variable "aws_region" {
  default     = "eu-central-1"
  description = "The region to use for this module."
}

variable "vpc_name" {
  description = "The name of the VPC. Other names will result from this."
}

variable "vpc_network" {
  default     = "10.0.0.0/24"
  description = "/24 Network within the Subnets will be created."
}

variable "sn_public_a_name" {
  description = "The name of the 1st Public Subnet which will be available in AZ-a."
  default     = "Public A"
}

variable "sn_public_b_name" {
  description = "The name of the 2nd Public Subnet which will be available in AZ-b."
  default     = "Public B"
}

variable "sn_private_a_name" {
  description = "The name of the 1st Public Subnet which will be available in AZ-a."
  default     = "Private A"
}

variable "sn_private_b_name" {
  description = "The name of the 1st Private Subnet which will be available in AZ-b."
  default     = "Private B"
}

variable "priv_nat" {
  description = "Create NAT GW for private subnet, create Internet GW for public subnet if set to true"
  default = true
}
