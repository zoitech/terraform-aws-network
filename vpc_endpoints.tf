# Endpoints

resource "aws_vpc_endpoint" "s3" {
  count  = local.create_vpcep_s3
  vpc_id = aws_vpc.main.id

  service_name = "com.amazonaws.${var.region}.s3"
  policy       = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "Policy1568307208199",
    "Statement": [
        {
            "Sid": "Stmt1568307206805",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:*",
            "Resource": "*"
        }
    ]
}
POLICY
  tags         = local.vpcep_s3_tags
}

# Route Table Associations

resource "aws_vpc_endpoint_route_table_association" "s3_public_rt" {
  route_table_id  = aws_route_table.rt_public.id
  vpc_endpoint_id = aws_vpc_endpoint.s3[0].id
}

resource "aws_vpc_endpoint_route_table_association" "s3_private_rt" {
  route_table_id  = aws_route_table.rt_private.id
  vpc_endpoint_id = aws_vpc_endpoint.s3[0].id
}
