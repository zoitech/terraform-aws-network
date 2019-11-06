# Private Subnets #
resource "aws_subnet" "sn_private_a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 3, 0)
  availability_zone = "${var.region}a"

  tags = {
    Name = var.sn_private_a_name
  }
}

resource "aws_subnet" "sn_private_b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 3, 1)
  availability_zone = "${var.region}b"
  tags = {
    Name = var.sn_private_b_name
  }
}

resource "aws_subnet" "sn_private_c" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 3, 2)
  availability_zone = "${var.region}c"
  tags = {
    Name = var.sn_private_c_name
  }
}

// resource "aws_subnet" "sn_private_d" {
//   vpc_id            = aws_vpc.vpc.id
//   cidr_block        = cidrsubnet(var.vpc_cidr_block, 3, 3)
//   availability_zone = "${var.region}d"
//   tags = {
//     Name = var.sn_private_d_name
//   }
// }

# Public Subnets #
resource "aws_subnet" "sn_public_a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 3, 4)
  availability_zone = "${var.region}a"

  tags = {
    Name = var.sn_public_a_name
  }
}

resource "aws_subnet" "sn_public_b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 3, 5)
  availability_zone = "${var.region}b"

  tags = {
    Name = var.sn_public_b_name
  }
}

resource "aws_subnet" "sn_public_c" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 3, 6)
  availability_zone = "${var.region}c"

  tags = {
    Name = var.sn_public_c_name
  }
}

// resource "aws_subnet" "sn_public_d" {
//   vpc_id            = aws_vpc.vpc.id
//   cidr_block        = cidrsubnet(var.vpc_cidr_block, 3, 7)
//   availability_zone = "${var.region}d"

//   tags = {
//     Name = var.sn_public_d_name
//   }
// }
