resource "aws_vpc_dhcp_options" "dhcp_options" {
  count                = local.create_dhcp
  domain_name          = var.dhcp_domain_name
  domain_name_servers  = var.domain_name_servers
  ntp_servers          = var.ntp_servers
  netbios_name_servers = var.netbios_name_servers
  netbios_node_type    = var.netbios_node_type

  tags = {
    Name = var.vpc_dhcp_options_tag_name
  }
}

resource "aws_vpc_dhcp_options_association" "dhcp_options" {
  count           = local.create_dhcp
  vpc_id          = aws_vpc.main.id
  dhcp_options_id = aws_vpc_dhcp_options.dhcp_options[count.index].id
}
