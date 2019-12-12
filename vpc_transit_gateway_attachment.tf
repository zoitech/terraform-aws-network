# 1.0.5n
resource "aws_ram_resource_share_accepter" "network_transit_gateway" {
  count     = local.create_tgw_attachment
  share_arn = var.share_arn
}

resource "aws_ec2_transit_gateway_vpc_attachment" "network_transit_gateway" {
  count              = local.create_tgw_attachment
  subnet_ids         = [aws_subnet.sn_private_a.id, aws_subnet.sn_private_b.id, aws_subnet.sn_private_c.id]
  transit_gateway_id = var.transit_gateway_id
  vpc_id             = aws_vpc.main.id

  tags = {
    Name = var.tgw_attachment_tag_name
  }
  # 1.0.5n
  depends_on = [
    aws_ram_resource_share_accepter.network_transit_gateway,
  ]
}
