resource "aws_ram_resource_share_accepter" "network_transit_gateway" {
  count     = local.accept_resource_share
  share_arn = var.share_arn
}

resource "aws_ec2_transit_gateway_vpc_attachment" "network_transit_gateway" {
  count = local.create_tgw_attachment
  # subnet_ids         = flatten([aws_subnet.sn_private_a[*].id, aws_subnet.sn_private_b[*].id, aws_subnet.sn_private_c[*].id])
  subnet_ids         = local.subnet_ids
  transit_gateway_id = var.transit_gateway_id
  vpc_id             = aws_vpc.main.id

  tags = {
    Name = var.tgw_attachment_tag_name
  }

  depends_on = [
    local.depends_on_aws_ram_resource_share_accepter_network_transit_gateway
  ]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "network_transit_gateway_without_ram" {
  count = local.create_tgw_attachment_without_ram
  # subnet_ids        = flatten([aws_subnet.sn_private_a[*].id, aws_subnet.sn_private_b[*].id, aws_subnet.sn_private_c[*].id])
  subnet_ids         = local.subnet_ids
  transit_gateway_id = var.transit_gateway_id
  vpc_id             = aws_vpc.main.id

  tags = {
    Name = var.tgw_attachment_tag_name
  }
}
