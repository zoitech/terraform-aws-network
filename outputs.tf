output "vpc_id" {
  value = local.create_network_resources == 1 ? aws_vpc.main[0].id : null
}

output "sn_public_a_ids" {
  value       = aws_subnet.sn_public_a.*.id
  description = "The ID of the 1st Public Subnet."
}

output "sn_public_b_ids" {
  value       = aws_subnet.sn_public_b.*.id
  description = "The ID of the 2nd Public Subnet."
}

output "sn_public_c_ids" {
  value       = aws_subnet.sn_public_c.*.id
  description = "The ID of the 3rd Public Subnet."
}

output "sn_private_a_ids" {
  value       = aws_subnet.sn_private_a.*.id
  description = "The ID of the 1st Private Subnet."
}

output "sn_private_b_ids" {
  value       = aws_subnet.sn_private_b.*.id
  description = "The ID of the 2nd Private Subnet."
}

output "sn_private_c_ids" {
  value       = aws_subnet.sn_private_c.*.id
  description = "The ID of the 3rd Private Subnet."
}

output "rt_public_id" {
  value       = local.create_network_resources == 1 ? aws_route_table.rt_public[0].id : null
  description = "The ID of the public route table."
}

output "rt_private_id" {
  value       = local.create_network_resources == 1 ? aws_route_table.rt_private[0].id : null
  description = "The ID of the private route table."
}

output "igw_id" {
  value       = local.create_igw == 1 ? aws_internet_gateway.igw[0].id : ""
  description = "The ID of the internet gateway."
}

output "nat_ip" {
  value       = local.create_nat == 1 ? aws_nat_gateway.natgw[0].public_ip : ""
  description = "The IP of the NAT Gateway."
}
