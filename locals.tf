locals {
  vpc_name                  = var.vpc_name
  create_dhcp               = (var.create_dhcp == true ? 1 : 0)
  vpc_dhcp_options_tag_name = "${var.vpc_dhcp_options_tag_name}-${var.domain_name}"
  create_igw                = (var.create_igw == true ? 1 : 0)
  create_nat                = (var.create_nat == true && var.create_igw == true ? 1 : 0)
  # acl for entire VPC
  create_network_acl       = (var.create_network_acl == true ? 1 : 0)
  create_network_acl_rules = (var.create_network_acl == true && var.network_acl_rules != null ? length(var.network_acl_rules) : 0)
  # acl for private subnets
  create_private_subnet_acl       = (var.create_private_subnet_acl == true ? 1 : 0)
  create_private_subnet_acl_rules = (var.create_private_subnet_acl == true && var.private_subnet_acl_rules != null ? length(var.private_subnet_acl_rules) : 0)
  # acl for public subnets
  create_public_subnet_acl       = (var.create_public_subnet_acl == true ? 1 : 0)
  create_public_subnet_acl_rules = (var.create_public_subnet_acl == true && var.public_subnet_acl_rules != null ? length(var.public_subnet_acl_rules) : 0)
  # tgw
  accept_resource_share                                              = (var.create_tgw_attachment == true && var.accept_resource_share == true ? 1 : 0)
  depends_on_aws_ram_resource_share_accepter_network_transit_gateway = (var.create_tgw_attachment == true && var.accept_resource_share == true ? aws_ram_resource_share_accepter.network_transit_gateway : null)
  create_tgw_attachment                                              = (var.create_tgw_attachment == true ? 1 : 0)
  create_private_tgw_routes                                          = (var.create_tgw_attachment == true && var.tgw_destination_cidr_blocks != [] ? length(var.tgw_destination_cidr_blocks) : 0)
}
