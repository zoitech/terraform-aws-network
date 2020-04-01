resource "aws_vpc" "main" {
  cidr_block           = var.vpc_network
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = {
    Name = var.vpc_name
  }
}

#