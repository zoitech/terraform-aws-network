resource "aws_vpc_ipv4_cidr_block_association" "additional_cidr" {
  for_each      = var.vpc_additional_cidr
  vpc_id        = aws_vpc.main.id
  cidr_block    = each.value
}