# route tables
resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.main.id

  tags = local.rt_public_tags
}

resource "aws_route_table" "rt_private" {
  vpc_id = aws_vpc.main.id

  tags = local.rt_private_tags
}

# route table associations
resource "aws_route_table_association" "rt_public_a" {
  count          = (local.enable_dynamic_subnets == true ? local.sn_public_a : 1)
  subnet_id      = aws_subnet.sn_public_a[count.index].id
  route_table_id = aws_route_table.rt_public.id
}

resource "aws_route_table_association" "rt_public_b" {
  count          = (local.enable_dynamic_subnets == true ? local.sn_public_b : 1)
  subnet_id      = aws_subnet.sn_public_b[count.index].id
  route_table_id = aws_route_table.rt_public.id
}

resource "aws_route_table_association" "rt_public_c" {
  count          = (local.enable_dynamic_subnets == true ? local.sn_public_c : 1)
  subnet_id      = aws_subnet.sn_public_c[count.index].id
  route_table_id = aws_route_table.rt_public.id
}

resource "aws_route_table_association" "rt_private_a" {
  count          = (local.enable_dynamic_subnets == true ? local.sn_private_a : 1)
  subnet_id      = aws_subnet.sn_private_a[count.index].id
  route_table_id = aws_route_table.rt_private.id
}

resource "aws_route_table_association" "rt_private_b" {
  count          = (local.enable_dynamic_subnets == true ? local.sn_private_b : 1)
  subnet_id      = aws_subnet.sn_private_b[count.index].id
  route_table_id = aws_route_table.rt_private.id
}

resource "aws_route_table_association" "rt_private_c" {
  count          = (local.enable_dynamic_subnets == true ? local.sn_private_c : 1)
  subnet_id      = aws_subnet.sn_private_c[count.index].id
  route_table_id = aws_route_table.rt_private.id
}

## VPC Endpoint

resource "aws_vpc_endpoint_route_table_association" "s3_public_rt" {
  count           = local.create_vpcep_s3
  vpc_endpoint_id = aws_vpc_endpoint.s3[0].id
  route_table_id  = element(aws_route_table.rt_public.*.id, count.index)


}

resource "aws_vpc_endpoint_route_table_association" "s3_private_rt" {
  count           = local.create_vpcep_s3
  vpc_endpoint_id = aws_vpc_endpoint.s3[0].id
  route_table_id  = element(aws_route_table.rt_private.*.id, count.index)

}

resource "aws_vpc_endpoint_route_table_association" "dynamodb_public_rt" {
  count           = local.create_vpcep_dynamodb
  vpc_endpoint_id = aws_vpc_endpoint.dynamodb[0].id
  route_table_id  = element(aws_route_table.rt_public.*.id, count.index)

}

resource "aws_vpc_endpoint_route_table_association" "dynamodb_private_rt" {
  count           = local.create_vpcep_dynamodb
  vpc_endpoint_id = aws_vpc_endpoint.dynamodb[0].id
  route_table_id  = element(aws_route_table.rt_private.*.id, count.index)

}

# routes
resource "aws_route" "rt_public_default" {
  count                  = local.create_igw
  route_table_id         = aws_route_table.rt_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw[count.index].id

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route" "rt_private_default" {
  count                  = local.create_nat
  route_table_id         = aws_route_table.rt_private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.natgw.0.id
}

# transit gateway
resource "aws_route" "rt_private_transit_gateway" {
  count                  = local.create_private_tgw_routes
  route_table_id         = aws_route_table.rt_private.id
  destination_cidr_block = element(var.tgw_destination_cidr_blocks, count.index)
  transit_gateway_id     = aws_ec2_transit_gateway_vpc_attachment.network_transit_gateway[0].transit_gateway_id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.network_transit_gateway,
  ]
}
