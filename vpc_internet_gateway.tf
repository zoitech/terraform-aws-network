# internet gateway
resource "aws_internet_gateway" "igw" {
  count  = local.create_igw
  vpc_id = aws_vpc.main.id

  tags =  length(var.igw_tags) != 0 ? merge({  "Name" = var.igw_tags }, var.igw_tags) : {} 

}
