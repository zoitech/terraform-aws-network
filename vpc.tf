resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_network}"
  tags {
    Name = "${var.vpc_name}"
  }
}
