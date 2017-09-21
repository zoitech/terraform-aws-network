# Public Subnets #
resource "aws_subnet" "sn_public_a" {
    vpc_id            = "${aws_vpc.main.id}"
    cidr_block        = "${cidrsubnet(var.vpc_network,2,0)}"
    availability_zone = "${var.aws_region}a"
    
    tags {
      Name = "${var.sn_public_a_name}"
    }
}

resource "aws_subnet" "sn_public_b" {
    vpc_id            = "${aws_vpc.main.id}"
    cidr_block        = "${cidrsubnet(var.vpc_network,2,1)}"
    availability_zone = "${var.aws_region}b"
    
    tags {
      Name = "${var.sn_public_b_name}"
    }
}

# Private Subnets #
resource "aws_subnet" "sn_private_a" {
    vpc_id            = "${aws_vpc.main.id}"
    cidr_block        = "${cidrsubnet(var.vpc_network,2,2)}"
    availability_zone = "${var.aws_region}a"
    
    tags {
      Name = "${var.sn_private_a_name}"
    }
}

resource "aws_subnet" "sn_private_b" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "${cidrsubnet(var.vpc_network,2,3)}"
    availability_zone = "${var.aws_region}b"
    tags {
      Name = "${var.sn_private_b_name}"
    }
}
