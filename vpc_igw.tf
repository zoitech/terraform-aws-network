### NAT and IGW ###
resource "aws_internet_gateway" "igw" {
  count = "${var.priv_nat}"
  vpc_id     = "${aws_vpc.main.id}"
}

# An Elastic IP is needed for a NAT Gateway.
resource "aws_eip" "natgw_eip" {
  count = "${var.priv_nat}"
  vpc = true
}

resource "aws_nat_gateway" "natgw" {
  count = "${var.priv_nat}"
  allocation_id = "${aws_eip.natgw_eip.id}"
  subnet_id     = "${aws_subnet.sn_public_a.id}"

  depends_on    = ["aws_internet_gateway.igw"]
}
