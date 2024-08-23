resource "aws_vpc_ipv4_cidr_block_association" "additional_cidr" {
  for_each      = toset(var.vpc_additional_cidr)
  vpc_id        = aws_vpc.main.id
  cidr_block    = each.value
}

# Additional Private Subnets #

resource "aws_subnet" "additional_sn_private_a" {
  count             = local.additional_sn_private_a
  vpc_id            = aws_vpc.main.id
  cidr_block        = (local.enable_dynamic_subnets == true ? var.additional_private_subnets_a[count.index] : cidrsubnet(var.vpc_additional_cidr[count.index], 3, 0))
  availability_zone = local.az1

  tags = merge(
    {
      Name = local.additional_sn_private_a > 0 ? "${var.additional_sn_private_a_name}${count.index+2}" : var.additional_sn_private_a_name 
    },
    length(var.additional_sn_private_a_tags) != 0 ? var.additional_sn_private_a_tags[count.index] : {}
  )

  depends_on = [aws_vpc_ipv4_cidr_block_association.additional_cidr]
}

resource "aws_subnet" "additional_sn_private_b" {
  count             = local.additional_sn_private_b
  vpc_id            = aws_vpc.main.id
  cidr_block        = (local.enable_dynamic_subnets == true ? var.additional_private_subnets_b[count.index] : cidrsubnet(var.vpc_additional_cidr[count.index], 3, 1))
  availability_zone = local.az2

  tags = merge(
    {
      Name = local.additional_sn_private_b > 0 ? "${var.additional_sn_private_b_name}${count.index+2}" : var.additional_sn_private_b_name
    },
    length(var.additional_sn_private_b_tags) != 0 ? var.additional_sn_private_b_tags[count.index] : {}
  )

  depends_on = [aws_vpc_ipv4_cidr_block_association.additional_cidr]
}

resource "aws_subnet" "additional_sn_private_c" {
  count             = local.additional_sn_private_c
  vpc_id            = aws_vpc.main.id
  cidr_block        = (local.enable_dynamic_subnets == true ? var.additional_private_subnets_c[count.index] : cidrsubnet(var.vpc_additional_cidr[count.index], 3, 2))
  availability_zone = local.az3

  tags = merge(
    {
      Name = local.additional_sn_private_c > 0 ? "${var.additional_sn_private_c_name}${count.index+2}" : var.additional_sn_private_c_name
    },
    length(var.additional_sn_private_c_tags) != 0 ? var.additional_sn_private_c_tags[count.index] : {}
  )

  depends_on = [aws_vpc_ipv4_cidr_block_association.additional_cidr]
}

# Additional Public Subnets #

resource "aws_subnet" "additional_sn_public_a" {
  count             = local.additional_sn_public_a
  vpc_id            = aws_vpc.main.id
  cidr_block        = (local.enable_dynamic_subnets == true ? var.additional_public_subnets_a[count.index] : cidrsubnet(var.vpc_additional_cidr[count.index], 3, 4))
  availability_zone = local.az1

  tags = merge(
    {
      Name = local.additional_sn_public_a > 0 ? "${var.additional_sn_public_a_name}${count.index+2}" : var.additional_sn_public_a_name
    },
    length(var.additional_sn_public_a_tags) != 0 ? var.additional_sn_public_a_tags[count.index] : {}
  )

  depends_on = [aws_vpc_ipv4_cidr_block_association.additional_cidr]
}


resource "aws_subnet" "additional_sn_public_b" {
  count             = local.additional_sn_public_b
  vpc_id            = aws_vpc.main.id
  cidr_block        = (local.enable_dynamic_subnets == true ? var.additional_public_subnets_b[count.index] : cidrsubnet(var.vpc_additional_cidr[count.index], 3, 5))
  availability_zone = local.az2

  tags = merge(
    {
      Name = local.additional_sn_public_b > 0 ? "${var.additional_sn_public_b_name}${count.index+2}" : var.additional_sn_public_b_name
    },
    length(var.additional_sn_public_b_tags) != 0 ? var.additional_sn_public_b_tags[count.index] : {}
  )

  depends_on = [aws_vpc_ipv4_cidr_block_association.additional_cidr]
}


resource "aws_subnet" "additional_sn_public_c" {
  count             = local.additional_sn_public_c
  vpc_id            = aws_vpc.main.id
  cidr_block        = (local.enable_dynamic_subnets == true ? var.additional_public_subnets_c[count.index] : cidrsubnet(var.vpc_additional_cidr[count.index], 3, 6))
  availability_zone = local.az3

  tags = merge(
    {
      Name = local.additional_sn_public_c > 0 ? "${var.additional_sn_public_c_name}${count.index+2}" : var.additional_sn_public_c_name
    },
    length(var.additional_sn_public_c_tags) != 0 ? var.additional_sn_public_c_tags[count.index] : {}
  )

  depends_on = [aws_vpc_ipv4_cidr_block_association.additional_cidr]
}

# route table associations
resource "aws_route_table_association" "additional_rt_private_a" {
  count          = (local.enable_dynamic_subnets == true ? local.additional_sn_private_a : 1)
  subnet_id      = aws_subnet.additional_sn_private_a[count.index].id
  route_table_id = aws_route_table.rt_private.id
}

resource "aws_route_table_association" "additional_rt_private_b" {
  count          = (local.enable_dynamic_subnets == true ? local.additional_sn_private_b : 1)
  subnet_id      = aws_subnet.additional_sn_private_b[count.index].id
  route_table_id = aws_route_table.rt_private.id
}

resource "aws_route_table_association" "additional_rt_private_c" {
  count          = (local.enable_dynamic_subnets == true ? local.additional_sn_private_c : 1)
  subnet_id      = aws_subnet.additional_sn_private_c[count.index].id
  route_table_id = aws_route_table.rt_private.id
}

resource "aws_route_table_association" "additional_rt_public_a" {
  count          = (local.enable_dynamic_subnets == true ? local.additional_sn_public_a : 1)
  subnet_id      = aws_subnet.additional_sn_public_a[count.index].id
  route_table_id = aws_route_table.rt_public.id
}
resource "aws_route_table_association" "additional_rt_public_b" {
  count          = (local.enable_dynamic_subnets == true ? local.additional_sn_public_b : 1)
  subnet_id      = aws_subnet.additional_sn_public_b[count.index].id
  route_table_id = aws_route_table.rt_public.id
}

resource "aws_route_table_association" "additional_rt_public_c" {
  count          = (local.enable_dynamic_subnets == true ? local.additional_sn_public_c : 1)
  subnet_id      = aws_subnet.additional_sn_public_c[count.index].id
  route_table_id = aws_route_table.rt_public.id
}