# Private Subnets #
# PRIVATE A
resource "aws_subnet" "sn_private_a" {
  count = local.sn_private_a  
  # count = (local.enable_dynamic_subnets == true ? local.sn_private_a : 1)
  vpc_id = aws_vpc.main.id
  # cidr_block = (var.vpc_network == "" ? cidrsubnet(var.vpc_network, 3, 0) : var.private_subnets_a[count.index])
  cidr_block = (local.enable_dynamic_subnets == true ? var.private_subnets_a[count.index] : cidrsubnet(var.vpc_network,3,0))
  availability_zone = "${var.region}a"

  tags = {
    # Name = (var.vpc_network == "" ? var.sn_private_a_name : "${var.sn_private_a_name}_${count.index}")
    Name = (local.enable_dynamic_subnets == true ? "${var.sn_private_a_name}_${count.index}" : var.sn_private_a_name)
  }
}

# PRIVATE B
resource "aws_subnet" "sn_private_b" {
  count = local.sn_private_b
  # count = (local.enable_dynamic_subnets == true ? local.sn_private_b : 1)
  vpc_id = aws_vpc.main.id
  # cidr_block = (var.vpc_network == "" ? cidrsubnet(var.vpc_network, 3, 1) : var.private_subnets_b[count.index])
  cidr_block = (local.enable_dynamic_subnets == true ? var.private_subnets_b[count.index] : cidrsubnet(var.vpc_network,3,1))
  availability_zone = "${var.region}b"
  tags = {
    # Name = (var.vpc_network == "" ?  var.sn_private_b_name : "${var.sn_private_b_name}_${count.index}")
    Name = (local.enable_dynamic_subnets == true ? "${var.sn_private_b_name}_${count.index}" : var.sn_private_b_name)
  }
}

# PRIVATE C
resource "aws_subnet" "sn_private_c" {
  count = local.sn_private_c
  # count = (local.enable_dynamic_subnets == true ? local.sn_private_c : 1)
  vpc_id = aws_vpc.main.id
  # cidr_block = (var.vpc_network == "" ? cidrsubnet(var.vpc_network, 3, 2) : var.private_subnets_c[count.index])
  cidr_block = (local.enable_dynamic_subnets == true ? var.private_subnets_c[count.index] : cidrsubnet(var.vpc_network,3,2))
  availability_zone = "${var.region}c"
  tags = {  
    # Name = (var.vpc_network == "" ?  var.sn_private_c_name : "${var.sn_private_c_name}_${count.index}")
    Name = (local.enable_dynamic_subnets == true ? "${var.sn_private_c_name}_${count.index}" : var.sn_private_c_name)
  }
}

# Public Subnets #
# PUBLIC A
resource "aws_subnet" "sn_public_a" {
  count = local.sn_public_a
  # count = (local.enable_dynamic_subnets == true ? local.sn_public_a : 1)
  vpc_id = aws_vpc.main.id
  # cidr_block        = (var.vpc_network == "" ? cidrsubnet(var.vpc_network, 3, 4) : var.public_subnets_a[count.index]) # cidrsubnet(var.vpc_network, 3, 4)
  cidr_block = (local.enable_dynamic_subnets == true ? var.public_subnets_a[count.index] : cidrsubnet(var.vpc_network,3,4))
  availability_zone = "${var.region}a"

  tags = {
    # Name = (var.vpc_network == "" ?  var.sn_public_a_name : "${var.sn_public_a_name}_${count.index}")
    Name = (local.enable_dynamic_subnets == true ? "${var.sn_public_a_name}_${count.index}" : var.sn_public_a_name)
  }
}

# PUBLIC B
resource "aws_subnet" "sn_public_b" {
  count = local.sn_public_b
  # count = (local.enable_dynamic_subnets == true ? local.sn_public_b : 1)
  vpc_id            = aws_vpc.main.id
  # cidr_block        = (var.vpc_network == "" ? cidrsubnet(var.vpc_network, 3, 5) : var.public_subnets_b[count.index])# cidrsubnet(var.vpc_network, 3, 4)
  cidr_block = (local.enable_dynamic_subnets == true ? var.public_subnets_b[count.index] : cidrsubnet(var.vpc_network, 3, 5))
  availability_zone = "${var.region}b"

  tags = {
    # Name = (var.vpc_network == "" ?  var.sn_public_b_name : "${var.sn_public_b_name}_${count.index}")
    Name = (local.enable_dynamic_subnets == true ? "${var.sn_public_b_name}_${count.index}" : var.sn_public_b_name)
  }
}

# PUBLIC C
resource "aws_subnet" "sn_public_c" {
  count = local.sn_public_c
  # count = (local.enable_dynamic_subnets == true ? local.sn_public_c : 1)
  vpc_id            = aws_vpc.main.id
  # cidr_block        = (var.vpc_network == "" ? cidrsubnet(var.vpc_network, 3, 6) : var.public_subnets_c[count.index])# cidrsubnet(var.vpc_network, 3, 5)
  cidr_block = (local.enable_dynamic_subnets == true ? var.public_subnets_c[count.index] : cidrsubnet(var.vpc_network, 3, 6))
  availability_zone = "${var.region}c"
  
  tags = {
    # Name = (var.vpc_network == "" ?  var.sn_public_c_name : "${var.sn_public_c_name}_${count.index}")
    Name = (local.enable_dynamic_subnets == true ? "${var.sn_public_c_name}_${count.index}" : var.sn_public_c_name)
  }
}