resource "aws_vpc" "main" {
  count                = local.create_network_resources
  cidr_block           = var.vpc_network
  enable_dns_hostnames = var.enable_dns_hostnames
  tags                 = merge({ "Name" = var.vpc_name }, var.vpc_tags)
}
