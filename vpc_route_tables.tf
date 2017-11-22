# Routes #
resource "aws_route_table" "rt_public" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "Public Route"
  }
}

resource "aws_route_table" "rt_private" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "Private Route"
  }
}

resource "aws_route" "rt_public_default" {
  route_table_id         = "${aws_route_table.rt_public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
}

resource "aws_route" "rt_private_default" {
  count                  = "${var.create_nat}"
  route_table_id         = "${aws_route_table.rt_private.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.natgw.id}"
}

resource "aws_route_table_association" "rt_public_a" {
  subnet_id      = "${aws_subnet.sn_public_a.id}"
  route_table_id = "${aws_route_table.rt_public.id}"
}

resource "aws_route_table_association" "rt_public_b" {
  subnet_id      = "${aws_subnet.sn_public_b.id}"
  route_table_id = "${aws_route_table.rt_public.id}"
}

resource "aws_route_table_association" "rt_private_a" {
  subnet_id      = "${aws_subnet.sn_private_a.id}"
  route_table_id = "${aws_route_table.rt_private.id}"
}

resource "aws_route_table_association" "rt_private_b" {
  subnet_id      = "${aws_subnet.sn_private_b.id}"
  route_table_id = "${aws_route_table.rt_private.id}"
}
