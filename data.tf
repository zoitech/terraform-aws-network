data "aws_caller_identity" "current" {
	count = local.create_network_resources
}
