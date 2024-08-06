# Muti-AZ NAT GW
resource "aws_eip" "natgw_eip_multiaz" {
  for_each = toset(var.nat_gw_azs)
  tags = {"Name" = "EIP NAT Gateway ${each.key}"} 

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_nat_gateway" "natgw_multiaz" {
  for_each = aws_eip.natgw_eip_multiaz

  allocation_id = each.value.id
  subnet_id     = local.nat_gw_multi_az_public_subnets[each.key]
  depends_on    = [aws_internet_gateway.igw]

  tags = merge(local.nat_gw_tags, {"Name" = "${var.vpc_name}-${each.key}"})

  lifecycle {
    ignore_changes = [tags]
  }
}

# Multi-AZ NATGW RT's
resource "aws_route_table" "rt_private_multiaz" {
  for_each = toset(var.nat_gw_azs)

  vpc_id = aws_vpc.main.id

  tags = merge(local.rt_private_tags, {"Name" = upper("Private Route ${each.key}")})

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_route" "rt_private_multiaz_ngw_route" {
  for_each = aws_nat_gateway.natgw_multiaz

  route_table_id         = aws_route_table.rt_private_multiaz[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = each.value.id
}

resource "aws_route" "rt_private_multiaz_tgw_route_1" {
  for_each = { for rt, values in aws_route_table.rt_private_multiaz : rt => values if var.create_tgw_attachment }

  route_table_id         = aws_route_table.rt_private_multiaz[each.key].id
  destination_cidr_block = "10.0.0.0/8"
  transit_gateway_id     = aws_ec2_transit_gateway_vpc_attachment.network_transit_gateway[0].transit_gateway_id
}

resource "aws_route" "rt_private_multiaz_tgw_route_2" {
  for_each = { for rt, values in aws_route_table.rt_private_multiaz : rt => values if var.create_tgw_attachment }

  route_table_id         = aws_route_table.rt_private_multiaz[each.key].id
  destination_cidr_block = "172.16.0.0/12"
  transit_gateway_id     = aws_ec2_transit_gateway_vpc_attachment.network_transit_gateway[0].transit_gateway_id
}

resource "aws_route" "rt_private_multiaz_tgw_route_3" {
  for_each = { for rt, values in aws_route_table.rt_private_multiaz : rt => values if var.create_tgw_attachment }

  route_table_id         = aws_route_table.rt_private_multiaz[each.key].id
  destination_cidr_block = "192.168.0.0/16"
  transit_gateway_id     = aws_ec2_transit_gateway_vpc_attachment.network_transit_gateway[0].transit_gateway_id
}

resource "aws_vpc_endpoint_route_table_association" "rt_private_multiaz_s3_endpoint" {
  for_each = { for rt, values in aws_route_table.rt_private_multiaz : rt => values if var.create_vpcep_s3 }

  vpc_endpoint_id = aws_vpc_endpoint.s3[0].id
  route_table_id  = aws_route_table.rt_private_multiaz[each.key].id
}

resource "aws_route_table_association" "rt_private_a_multiaz" {
  count          = local.multiaz_a_required ? length(var.private_subnets_a) : 0
  subnet_id      = aws_subnet.sn_private_a[count.index].id
  route_table_id = aws_route_table.rt_private_multiaz["a"].id
}

resource "aws_route_table_association" "rt_private_b_multiaz" {
  count          = local.multiaz_b_required ? length(var.private_subnets_b) : 0
  subnet_id      = aws_subnet.sn_private_b[count.index].id
  route_table_id = aws_route_table.rt_private_multiaz["b"].id
}

resource "aws_route_table_association" "rt_private_c_multiaz" {
  count          = local.multiaz_c_required ? length(var.private_subnets_c) : 0
  subnet_id      = aws_subnet.sn_private_c[count.index].id
  route_table_id = aws_route_table.rt_private_multiaz["c"].id
}