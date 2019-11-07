resource "aws_network_acl" "vpc_acl" {
  count      = local.create_network_acl
  vpc_id     = aws_vpc.main.id
  subnet_ids = [aws_subnet.sn_private_a.id, aws_subnet.sn_private_b.id, aws_subnet.sn_private_c.id, aws_subnet.sn_public_a.id, aws_subnet.sn_public_b.id, aws_subnet.sn_public_c.id, ]

  tags = {
    Name = var.network_acl_tag_name
  }
}

# default allow inbounc all in
resource "aws_network_acl_rule" "allow_all_ingress_in" {
  count          = local.create_network_acl
  network_acl_id = aws_network_acl.vpc_acl[0].id
  rule_number    = 32766
  egress         = false
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

# default allow outbound all out
resource "aws_network_acl_rule" "allow_all_egress_out" {
  count          = local.create_network_acl
  network_acl_id = aws_network_acl.vpc_acl[0].id
  rule_number    = 32766
  egress         = true
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}


resource "aws_network_acl_rule" "acl_rule_deny" {
  count          = local.create_network_acl_rules
  network_acl_id = aws_network_acl.vpc_acl[0].id
  rule_number    = lookup(element(var.network_acl_rules, count.index), "rule_number")
  egress         = lookup(element(var.network_acl_rules, count.index), "egress")
  protocol       = lookup(element(var.network_acl_rules, count.index), "protocol")
  rule_action    = lookup(element(var.network_acl_rules, count.index), "rule_action")
  cidr_block     = lookup(element(var.network_acl_rules, count.index), "cidr_block")
  from_port      = lookup(element(var.network_acl_rules, count.index), "from_port")
  to_port        = lookup(element(var.network_acl_rules, count.index), "to_port")
}
