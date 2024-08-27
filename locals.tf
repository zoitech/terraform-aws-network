locals {
  vpc_name    = var.vpc_name
  create_dhcp = (var.create_dhcp == true ? 1 : 0)
  create_igw  = (var.create_igw == true && local.public_subnet_defined == true ? 1 : 0)
  create_nat  = (var.create_nat == true && var.create_igw == true && local.public_subnet_defined == true ? 1 : 0)

  # If creating dynamic subnets, check if any public subnets have been defined.
  public_subnet_defined = (local.enable_dynamic_subnets == false ? true : (length(var.public_subnets_a) > 0 || length(var.public_subnets_b) > 0 || length(var.public_subnets_c) > 0 ? true : false))

  # Public Subnet to be attached to the NAT Gateway
  vpc_nat_gateway_subnet_id = (local.enable_dynamic_subnets == true ? (local.sn_public_a > 0 ? aws_subnet.sn_public_a.0.id : (local.sn_public_b > 0 ? aws_subnet.sn_public_b.0.id : (local.sn_public_c > 0 ? aws_subnet.sn_public_c.0.id : null))) : aws_subnet.sn_public_a.0.id)

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
  create_tgw_attachment_without_ram                                  = (var.create_tgw_attachment_without_ram == true ? 1 : 0)
  create_private_tgw_routes                                          = (var.create_tgw_attachment == true && var.tgw_destination_cidr_blocks != [] ? length(var.tgw_destination_cidr_blocks) : 0)

  #Enable Dynamic Subnets:
  enable_dynamic_subnets = (length(var.private_subnets_a) > 0 || length(var.private_subnets_b) > 0 || length(var.private_subnets_c) > 0 || length(var.public_subnets_a) > 0 || length(var.public_subnets_b) > 0 || length(var.public_subnets_c) > 0 ? true : false)

  # Custom subnets
  # Private:
  sn_private_a = (local.enable_dynamic_subnets == false ? 1 : (length(var.private_subnets_a) > 0 ? length(var.private_subnets_a) : 0))
  sn_private_b = (local.enable_dynamic_subnets == false ? 1 : (length(var.private_subnets_b) > 0 ? length(var.private_subnets_b) : 0))
  sn_private_c = (local.enable_dynamic_subnets == false ? 1 : (length(var.private_subnets_c) > 0 ? length(var.private_subnets_c) : 0))

  # Public: 
  sn_public_a = (local.enable_dynamic_subnets == false ? 1 : (length(var.public_subnets_a) > 0 ? length(var.public_subnets_a) : 0))
  sn_public_b = (local.enable_dynamic_subnets == false ? 1 : (length(var.public_subnets_b) > 0 ? length(var.public_subnets_b) : 0))
  sn_public_c = (local.enable_dynamic_subnets == false ? 1 : (length(var.public_subnets_c) > 0 ? length(var.public_subnets_c) : 0))

  # Private subnet to be attached to TGW.
  private_a_tgw_attachment            = local.sn_private_a > 0 ? tolist([(var.tgw_attachment_aza_subnet >= 0 ? aws_subnet.sn_private_a[var.tgw_attachment_aza_subnet].id : aws_subnet.sn_private_a[0].id)]) : []
  private_b_tgw_attachment            = local.sn_private_b > 0 ? tolist([(var.tgw_attachment_azb_subnet >= 0 ? aws_subnet.sn_private_b[var.tgw_attachment_azb_subnet].id : aws_subnet.sn_private_b[0].id)]) : []
  private_c_tgw_attachment            = local.sn_private_c > 0 ? tolist([(var.tgw_attachment_azc_subnet >= 0 ? aws_subnet.sn_private_c[var.tgw_attachment_azc_subnet].id : aws_subnet.sn_private_c[0].id)]) : []
  subnet_ids                          = flatten([local.private_a_tgw_attachment, local.private_b_tgw_attachment, local.private_c_tgw_attachment])

  #igw_tags
  igw_tags = merge({ "Name" = var.vpc_name }, var.igw_tags)

  #nat_gw_tags
  nat_gw_tags = merge({ "Name" = var.vpc_name }, var.nat_gw_tags)

  # Route table tags
  rt_private_name = "Private Route"
  rt_public_name  = "Public Route"
  rt_private_tags = merge({ "Name" = local.rt_private_name }, var.rt_private_tags)
  rt_public_tags  = merge({ "Name" = local.rt_public_name }, var.rt_public_tags)

  # VPC Endpoints
  create_vpcep_s3 = (var.create_vpcep_s3 == true ? 1 : 0)
  vpcep_s3_tags   = merge({ "Name" = var.vpcep_s3_name }, var.vpcep_s3_tags)

  create_vpcep_dynamodb = (var.create_vpcep_dynamodb == true ? 1 : 0)
  vpcep_dynamodb_tags   = merge({ "Name" = var.vpcep_dynamodb_name }, var.vpcep_dynamodb_tags)

  # Enable dynamic AZs
  enable_dynamic_az1 = (length(var.az1) > 0 ? true : false)
  enable_dynamic_az2 = (length(var.az2) > 0 ? true : false)
  enable_dynamic_az3 = (length(var.az3) > 0 ? true : false)

  # Availability Zones
  az1 = (local.enable_dynamic_az1 == false ? "${var.region}a" : var.az1)
  az2 = (local.enable_dynamic_az2 == false ? "${var.region}b" : var.az2)
  az3 = (local.enable_dynamic_az3 == false ? "${var.region}c" : var.az3)

  #Multi-AZ NAT GW subnets
  nat_gw_multi_az_public_subnets = {
    "a" = local.enable_dynamic_subnets ? aws_subnet.sn_public_a.0.id : null
    "b" = local.enable_dynamic_subnets ? aws_subnet.sn_public_b.0.id : null
    "c" = local.enable_dynamic_subnets ? aws_subnet.sn_public_c.0.id : null
  }

  multiaz_a_required = var.private_subnet_rt_per_az_association && contains(var.nat_gw_azs, "a")
  multiaz_b_required = var.private_subnet_rt_per_az_association && contains(var.nat_gw_azs, "b")
  multiaz_c_required = var.private_subnet_rt_per_az_association && contains(var.nat_gw_azs, "c")

  # Additional CIDRs to VPC
  enable_additional_cidr = (length(var.vpc_additional_cidr) > 0 ? true : false)
  enable_additional_dynamic_subnets = (length(var.additional_private_subnets_a) > 0 || length(var.additional_private_subnets_b) > 0 || length(var.additional_private_subnets_c) > 0 || length(var.additional_public_subnets_a) > 0 || length(var.additional_public_subnets_b) > 0 || length(var.additional_public_subnets_c) > 0 ? true : false)
  additional_sn_private_a = (length(var.vpc_additional_cidr) > 0 ? (local.enable_additional_dynamic_subnets == false ? 1 : (length(var.additional_private_subnets_a) > 0 ? length(var.additional_private_subnets_a) : 0)) : 0)
  additional_sn_private_b = (length(var.vpc_additional_cidr) > 0 ? (local.enable_additional_dynamic_subnets == false ? 1 : (length(var.additional_private_subnets_b) > 0 ? length(var.additional_private_subnets_b) : 0)) : 0)
  additional_sn_private_c = (length(var.vpc_additional_cidr) > 0 ? (local.enable_additional_dynamic_subnets == false ? 1 : (length(var.additional_private_subnets_c) > 0 ? length(var.additional_private_subnets_c) : 0)) : 0)
  additional_sn_public_a = (length(var.vpc_additional_cidr) > 0 ? (local.enable_additional_dynamic_subnets == false ? 1 : (length(var.additional_public_subnets_a) > 0 ? length(var.additional_public_subnets_a) : 0)) : 0)
  additional_sn_public_b = (length(var.vpc_additional_cidr) > 0 ? (local.enable_additional_dynamic_subnets == false ? 1 : (length(var.additional_public_subnets_b) > 0 ? length(var.additional_public_subnets_b) : 0)) : 0)
  additional_sn_public_c = (length(var.vpc_additional_cidr) > 0 ? (local.enable_additional_dynamic_subnets == false ? 1 : (length(var.additional_public_subnets_c) > 0 ? length(var.additional_public_subnets_c) : 0)) : 0)

}
