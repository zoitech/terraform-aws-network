output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "sn_public_a_id" {
  value       = aws_subnet.sn_public_a.id
  description = "The ID of the 1st Public Subnet."
}

output "sn_public_b_id" {
  value       = aws_subnet.sn_public_b.id
  description = "The ID of the 2nd Public Subnet."
}

output "sn_public_c_id" {
  value       = aws_subnet.sn_public_c.id
  description = "The ID of the 3rd Public Subnet."
}

// output "sn_public_d_id" {
//   value       = aws_subnet.sn_public_d.id
//   description = "The ID of the 4th Public Subnet."
// }

output "sn_private_a_id" {
  value       = aws_subnet.sn_private_a.id
  description = "The ID of the 1st Private Subnet."
}

output "sn_private_b_id" {
  value       = aws_subnet.sn_private_b.id
  description = "The ID of the 2nd Private Subnet."
}

output "sn_private_c_id" {
  value       = aws_subnet.sn_private_c.id
  description = "The ID of the 3rd Private Subnet."
}

// output "sn_private_d_id" {
//   value       = aws_subnet.sn_private_d.id
//   description = "The ID of the 4th Private Subnet."
// }

output "rt_public_id" {
  value       = aws_route_table.rt_public.id
  description = "The ID of the public route table."
}

output "rt_private_id" {
  value       = aws_route_table.rt_private.id
  description = "The ID of the private route table."
}
output "nat_ip" {
  value       = aws_nat_gateway.natgw.*.public_ip
  description = "The IP of the NAT Gateway."
}
