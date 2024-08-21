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
      module.docker_example_lambda_function.lambda_function_arn,
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
