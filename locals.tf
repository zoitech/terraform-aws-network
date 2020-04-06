locals {
  vpc_name    = var.vpc_name
  create_dhcp = (var.create_dhcp == true ? 1 : 0)
  create_igw  = (var.create_igw == true ? 1 : 0)
  create_nat  = (var.create_nat == true && var.create_igw == true && local.public_subnet_defined == true? 1 : 0)
  
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

#Enable Dynamic Subnets:
enable_dynamic_subnets = (length(var.private_subnets_a) > 0 || length(var.private_subnets_b) > 0 || length(var.private_subnets_c) > 0 || length(var.public_subnets_a) > 0 || length(var.public_subnets_b) > 0 || length(var.public_subnets_c) > 0  ? true : false)

  # Custom subnets
  # Private:
  # sn_private_a = (length(var.private_subnets_a) > 0 && local.enable_dynamic_subnets == true ? length(var.private_subnets_a) : 1) 
  # sn_private_b = (length(var.private_subnets_b) > 0 && local.enable_dynamic_subnets == true ? length(var.private_subnets_b) : 1)
  # sn_private_c = (length(var.private_subnets_c) > 0 && local.enable_dynamic_subnets == true ? length(var.private_subnets_c) : 1)
  
  sn_private_a = (local.enable_dynamic_subnets == false ? 1 : (length(var.private_subnets_a) > 0 ? length(var.private_subnets_a) : 0) )
  sn_private_b = (local.enable_dynamic_subnets == false ? 1 : (length(var.private_subnets_b) > 0 ? length(var.private_subnets_b) : 0)) 
  sn_private_c = (local.enable_dynamic_subnets == false ? 1 : (length(var.private_subnets_c) > 0 ? length(var.private_subnets_c) : 0)) 


  # Public: 
  # sn_public_a = (var.vpc_network == "" ? 1 : length(var.public_subnets_a))
  # sn_public_b = (var.vpc_network == "" ? 1 : length(var.public_subnets_b))
  # sn_public_c = (var.vpc_network == "" ? 1 : length(var.public_subnets_c))
  # sn_public_a = (length(var.public_subnets_a) > 0 && local.enable_dynamic_subnets == true ? length(var.public_subnets_a) : 1)
  # sn_public_b = (length(var.public_subnets_b) > 0 && local.enable_dynamic_subnets == true ? length(var.public_subnets_b) : 1)
  # sn_public_c = (length(var.public_subnets_c) > 0 && local.enable_dynamic_subnets == true ? length(var.public_subnets_c) : 1)
  sn_public_a = (local.enable_dynamic_subnets == false ? 1 : (length(var.public_subnets_a) > 0 ? length(var.public_subnets_a) : 0))
  sn_public_b = (local.enable_dynamic_subnets == false ? 1 : (length(var.public_subnets_b) > 0 ? length(var.public_subnets_b) : 0)) 
  sn_public_c = (local.enable_dynamic_subnets == false ? 1 : (length(var.public_subnets_c) > 0 ? length(var.public_subnets_c) : 0)) 

  # If creating dynamic subnets, check if the public subnets have been defined.
  public_subnet_defined = (length(var.public_subnets_a) > 0 || length(var.public_subnets_b) > 0 || length(var.public_subnets_c) > 0 ? true : false)
  
  # Public Subnet to be attached to the NAT Gateway
  vpc_nat_gateway_subnet_id = (length(var.public_subnets_a) > 0 ? aws_subnet.sn_public_a.0.id : (length(var.public_subnets_b) > 0 ? aws_subnet.sn_public_b.0.id : (length(var.public_subnets_c) > 0 ? aws_subnet.sn_public_c.0.id : "")))
}