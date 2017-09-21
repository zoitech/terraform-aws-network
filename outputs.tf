output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "sn_public_a_id" {
  value       = "${aws_subnet.sn_public_a.id}"
  description = "The ID of the 1st Public Subnet."
}

output "sn_public_b_id" {
  value = "${aws_subnet.sn_public_b.id}"
  description = "The ID of the 2nd Public Subnet."
}

output "sn_private_a_id" {
  value = "${aws_subnet.sn_private_a.id}"
  description = "The ID of the 1st Private Subnet."
}

output "sn_private_b_id" {
  value = "${aws_subnet.sn_private_b.id}"
  description = "The ID of the 2nd Private Subnet."
}

output "rt_public_id" {
  value = "${aws_route_table.rt_public.id}"
}

output "rt_private_id" {
  value = "${aws_route_table.rt_private.id}"
}
