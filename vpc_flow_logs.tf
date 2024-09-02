###### VPC flow logs for S3 ######

resource "aws_s3_bucket" "bucket" {
  count = var.vpc_flow_log_bucket_name != "" ? 1 : 0

  bucket = var.vpc_flow_log_bucket_name
  tags = {
    "Name"     = var.vpc_flow_log_bucket_name,
    "role"     = "storage"
    "creation" = "terraform"
  }
}

data "aws_iam_policy_document" "s3_bucket_policy_doc" {
  count = var.vpc_flow_log_bucket_name != "" ? 1 : 0

  statement {
    sid = "AWSLogDeliveryWrite"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    actions = ["s3:PutObject"]

    resources = ["${aws_s3_bucket.bucket[0].arn}/*"]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:*"]
    }
  }

  statement {
    sid = "AWSLogDeliveryAclCheck"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    actions = [
      "s3:GetBucketAcl",
      "s3:ListBucket"
    ]

    resources = [aws_s3_bucket.bucket[0].arn]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:*"]
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  count = var.vpc_flow_log_bucket_name != "" ? 1 : 0

  bucket = aws_s3_bucket.bucket[0].id
  policy = data.aws_iam_policy_document.s3_bucket_policy_doc[0].json
}

resource "aws_s3_bucket_lifecycle_configuration" "bucket_expiration_rule" {
  count = var.vpc_flow_log_bucket_name != "" ? 1 : 0

  bucket = aws_s3_bucket.bucket[0].id
  rule {
    id     = "expire-objects-rule"
    status = "Enabled"

    expiration {
      days = var.vpc_flow_log_retention_period
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  count = var.vpc_flow_log_bucket_name != "" && var.vpc_flow_log_kms_key_arn != "" ? 1 : 0

  bucket = aws_s3_bucket.bucket[0].id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.vpc_flow_log_kms_key_arn
      sse_algorithm     = "aws:kms"
    }
    bucket_key_enabled = true
  }
}

resource "aws_flow_log" "flow_log_s3" {
  count = var.vpc_flow_log_bucket_name != "" ? 1 : 0

  log_destination      = aws_s3_bucket.bucket[0].arn
  log_destination_type = "s3"
  traffic_type         = var.vpc_flow_log_traffic_type
  vpc_id               = aws_vpc.main.id
  log_format           = var.vpc_flow_log_custom_format != "" ? var.vpc_flow_log_custom_format : null
  destination_options {
    file_format        = "parquet"
    per_hour_partition = true
  }
}

###### VPC flow logs for Cloudwatch logs ######

resource "aws_cloudwatch_log_group" "cw_log" {
  count = var.vpc_flow_log_cw_log_group_name != "" ? 1 : 0

  name              = var.vpc_flow_log_cw_log_group_name
  retention_in_days = var.vpc_flow_log_retention_period
  kms_key_id        = var.vpc_flow_log_kms_key_arn != "" ? var.vpc_flow_log_kms_key_arn : null
  tags = {
    "Name"     = var.vpc_flow_log_cw_log_group_name,
    "role"     = "storage"
    "creation" = "terraform"
  }
}

data "aws_iam_policy_document" "assume_role" {
  count = var.vpc_flow_log_cw_log_group_name != "" ? 1 : 0

  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "cw_log_role" {
  count = var.vpc_flow_log_cw_log_group_name != "" ? 1 : 0

  name               = "zoi-vpc-flow-logs-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role[0].json
}

data "aws_iam_policy_document" "cw_policy_doc" {
  count = var.vpc_flow_log_cw_log_group_name != "" ? 1 : 0

  statement {
    effect = "Allow"

    actions = [
      "logs:DescribeLogGroups"
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = ["${aws_cloudwatch_log_group.cw_log[0].arn}:*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "logs:DescribeLogStreams",
      "logs:CreateLogGroup"
    ]

    resources = [aws_cloudwatch_log_group.cw_log[0].arn]
  }
}

resource "aws_iam_role_policy" "cw_policy" {
  count = var.vpc_flow_log_cw_log_group_name != "" ? 1 : 0

  name   = "vpc-cw-log-policy"
  role   = aws_iam_role.cw_log_role[0].id
  policy = data.aws_iam_policy_document.cw_policy_doc[0].json
}

resource "aws_flow_log" "flow_log_cw" {
  count = var.vpc_flow_log_cw_log_group_name != "" ? 1 : 0

  log_destination      = aws_cloudwatch_log_group.cw_log[0].arn
  log_destination_type = "cloud-watch-logs"
  iam_role_arn         = aws_iam_role.cw_log_role[0].arn
  traffic_type         = var.vpc_flow_log_traffic_type
  vpc_id               = aws_vpc.main.id
  log_format           = var.vpc_flow_log_custom_format != "" ? var.vpc_flow_log_custom_format : null
}