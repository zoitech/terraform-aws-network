# An Elastic IP is needed for a NAT Gateway.
resource "aws_eip" "natgw_eip" {
  count = local.create_nat
}

resource "aws_nat_gateway" "natgw" {
  count         = local.create_nat 
  allocation_id = aws_eip.natgw_eip.0.id
  subnet_id = local.vpc_nat_gateway_subnet_id
  depends_on = [aws_internet_gateway.igw]

  tags =  length(var.nat_gw_tags) != 0 ? merge({  "Name" = var.nat_gw_tags }, var.nat_gw_tags) : {} 
}