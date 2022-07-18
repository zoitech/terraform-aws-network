# Private Subnets #
# PRIVATE A
resource "aws_subnet" "sn_private_a" {
  count             = local.sn_private_a
  vpc_id            = aws_vpc.main.id
  cidr_block        = (local.enable_dynamic_subnets == true ? var.private_subnets_a[count.index] : cidrsubnet(var.vpc_network, 3, 0))
  availability_zone = local.az1

  tags = merge(
    {
      Name = local.sn_private_a > 1 ? "${var.sn_private_a_name}_${count.index}" : var.sn_private_a_name
    },
    length(var.sn_private_a_tags) != 0 ? var.sn_private_a_tags[count.index] : {}
  )
}

# PRIVATE B
resource "aws_subnet" "sn_private_b" {
  count             = local.sn_private_b
  vpc_id            = aws_vpc.main.id
  cidr_block        = (local.enable_dynamic_subnets == true ? var.private_subnets_b[count.index] : cidrsubnet(var.vpc_network, 3, 1))
  availability_zone = local.az2

  tags = merge(
    {
      Name = local.sn_private_b > 1 ? "${var.sn_private_b_name}_${count.index}" : var.sn_private_b_name
    },
    length(var.sn_private_b_tags) != 0 ? var.sn_private_b_tags[count.index] : {}
  )
}

# PRIVATE C
resource "aws_subnet" "sn_private_c" {
  count             = local.sn_private_c
  vpc_id            = aws_vpc.main.id
  cidr_block        = (local.enable_dynamic_subnets == true ? var.private_subnets_c[count.index] : cidrsubnet(var.vpc_network, 3, 2))
  availability_zone = local.az3

  tags = merge(
    {
      Name = local.sn_private_c > 1 ? "${var.sn_private_c_name}_${count.index}" : var.sn_private_c_name
    },
    length(var.sn_private_c_tags) != 0 ? var.sn_private_c_tags[count.index] : {}
  )
}

# Public Subnets #
# PUBLIC A
resource "aws_subnet" "sn_public_a" {
  count             = local.sn_public_a
  vpc_id            = aws_vpc.main.id
  cidr_block        = (local.enable_dynamic_subnets == true ? var.public_subnets_a[count.index] : cidrsubnet(var.vpc_network, 3, 4))
  availability_zone = local.az1
  map_public_ip_on_launch = var.auto_assign_public_ip

  tags = merge(
    {
      Name = local.sn_public_a > 1 ? "${var.sn_public_a_name}_${count.index}" : var.sn_public_a_name
    },
    length(var.sn_public_a_tags) != 0 ? var.sn_public_a_tags[count.index] : {}
  )
}

# PUBLIC B
resource "aws_subnet" "sn_public_b" {
  count             = local.sn_public_b
  vpc_id            = aws_vpc.main.id
  cidr_block        = (local.enable_dynamic_subnets == true ? var.public_subnets_b[count.index] : cidrsubnet(var.vpc_network, 3, 5))
  availability_zone = local.az2
  map_public_ip_on_launch = var.auto_assign_public_ip

  tags = merge(
    {
      Name = local.sn_public_b > 1 ? "${var.sn_public_b_name}_${count.index}" : var.sn_public_b_name
    },
    length(var.sn_public_b_tags) != 0 ? var.sn_public_b_tags[count.index] : {}
  )
}

# PUBLIC C
resource "aws_subnet" "sn_public_c" {
  count             = local.sn_public_c
  vpc_id            = aws_vpc.main.id
  cidr_block        = (local.enable_dynamic_subnets == true ? var.public_subnets_c[count.index] : cidrsubnet(var.vpc_network, 3, 6))
  availability_zone = local.az3
  map_public_ip_on_launch = var.auto_assign_public_ip

  tags = merge(
    {
      Name = local.sn_public_c > 1 ? "${var.sn_public_c_name}_${count.index}" : var.sn_public_c_name
    },
    length(var.sn_public_c_tags) != 0 ? var.sn_public_c_tags[count.index] : {}
  )
}
