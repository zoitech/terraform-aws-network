# route tables
resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Public Route"
  }
}

resource "aws_route_table" "rt_private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Private Route"
  }
}

# route table associations
resource "aws_route_table_association" "rt_public_a" {
  subnet_id      = aws_subnet.sn_public_a.id
  route_table_id = aws_route_table.rt_public.id
}

resource "aws_route_table_association" "rt_public_b" {
  subnet_id      = aws_subnet.sn_public_b.id
  route_table_id = aws_route_table.rt_public.id
}

resource "aws_route_table_association" "rt_public_c" {
  subnet_id      = aws_subnet.sn_public_c.id
  route_table_id = aws_route_table.rt_public.id
}

// resource "aws_route_table_association" "rt_public_d" {
//   subnet_id      = aws_subnet.sn_public_d.id
//   route_table_id = aws_route_table.rt_public.id
// }

resource "aws_route_table_association" "rt_private_a" {
  subnet_id      = aws_subnet.sn_private_a.id
  route_table_id = aws_route_table.rt_private.id
}

resource "aws_route_table_association" "rt_private_b" {
  subnet_id      = aws_subnet.sn_private_b.id
  route_table_id = aws_route_table.rt_private.id
}

resource "aws_route_table_association" "rt_private_c" {
  subnet_id      = aws_subnet.sn_private_c.id
  route_table_id = aws_route_table.rt_private.id
}


// resource "aws_route_table_association" "rt_private_d" {
//   subnet_id      = aws_subnet.sn_private_d.id
//   route_table_id = aws_route_table.rt_private.id
// }

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
