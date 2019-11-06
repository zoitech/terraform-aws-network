locals {
  vpc_name                  = var.vpc_name
  create_dhcp               = (var.create_dhcp == true ? 1 : 0)
  vpc_dhcp_options_tag_name = "${var.vpc_dhcp_options_tag_name}-${var.domain_name}"
  create_igw                = (var.create_igw == true ? 1 : 0)
  create_nat                = (var.create_nat == true && var.create_igw == true ? 1 : 0)
  create_network_acl        = (var.create_network_acl == true ? 1 : 0)
  create_network_acl_rules  = (var.network_acl_rules != null ? length(var.network_acl_rules) : 0)
  create_tgw_attachment     = (var.create_tgw_attachment == true ? 1 : 0)
}
