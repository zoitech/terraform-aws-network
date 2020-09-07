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

resource "aws_vpc_endpoint" "dynamodb" {
  count  = local.create_vpcep_dynamodb
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
            "Action": "dynamodb:*",
            "Resource": "*"
        }
    ]
}
POLICY
  tags         = local.vpcep_dynamodb_tags
}
