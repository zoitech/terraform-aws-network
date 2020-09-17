# internet gateway
resource "aws_internet_gateway" "igw" {
  count  = local.create_igw
  vpc_id = aws_vpc.main.id

  tags = local.igw_tags

}
