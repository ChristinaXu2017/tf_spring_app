# allow cloudfront to access s3
resource "aws_s3_bucket_policy" "app_website_access" {
  bucket = aws_s3_bucket.app_bucket.id
  policy = data.aws_iam_policy_document.app_website_access.json
}

# iam policy
data "aws_iam_policy_document" "app_website_access" {
  statement {
    principals {
      type = "Service"
      identifiers = [
        "cloudfront.amazonaws.com"
      ]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.app_bucket.arn}/frontend/*",
      "${aws_s3_bucket.app_bucket.arn}/jobs/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values = [
        aws_cloudfront_distribution.app_distribution.arn
      ]
    }
  }
}

# example allow s3 full for jobs directory
data "aws_iam_policy_document" "app_jobs_s3_access" {
  statement {
    actions = [
      "s3:*",
    ]

    resources = [
      "${aws_s3_bucket.app_bucket.arn}/jobs/*",
    ]
  }
}

# example allow lambda invoke for api
data "aws_iam_policy_document" "app_lambda_invoke" {
  statement {
    actions = [
      "lambda:InvokeFunction",
    ]

    resources = [
      module.start_jupyter_lambda_function.lambda_function_arn,
      module.stop_jupyter_lambda_function.lambda_function_arn
    ]
  }
}

# example allow dynamodb access
data "aws_iam_policy_document" "app_dynamodb_access" {
  statement {
    actions = [
      "dynamodb:*",
    ]

    resources = [
      aws_dynamodb_table.example_table.arn,
    ]
  }
}
######### create new iam role  to access S3 and ECS tasks ###############3
resource "aws_iam_role" "pipeline_role" {
  name = "pipeline_role"
  description = "Role for EC2 instances to pull Docker images from ECR and access S3"
  
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      { 
        "Effect": "Allow",
        "Principal": { "Service": "ec2.amazonaws.com" },
        "Action": "sts:AssumeRole"
      }
    ]
  })
 # Attach managed policies for S3 full access and SSM access
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
}

# Define an inline policy for EC2, ECR, and IAM actions
resource "aws_iam_role_policy" "pipeline_inline_policy" {
  name   = "pipeline_inline_policy"
  role   = aws_iam_role.pipeline_role.id

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [ "iam:PassRole", "ec2:*", "ecr:*", "ssm:SendCommand", "ssm:GetCommandInvocation" ],
        "Resource": "*"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "pipeline_role_instance_profile"
  role = aws_iam_role.pipeline_role.name
}