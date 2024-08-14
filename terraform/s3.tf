resource "aws_s3_bucket" "app_bucket" {
  bucket_prefix = "${var.app-name}-bucket-"

  tags = var.tags
}

# an example where we expire files after 100 days
resource "aws_s3_bucket_lifecycle_configuration" "app_bucket_lifecycle_configuration" {
  bucket = aws_s3_bucket.app_bucket.id

  rule {
    id     = "expire old job files"
    status = "Enabled"

    filter {
      prefix = "data/"
    }

    expiration {
      days = 100
    }
  }
}

# allow cors, this helps users to download data using signed urls
resource "aws_s3_bucket_cors_configuration" "app_bucket_cors_configuration" {
  bucket = aws_s3_bucket.app_bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST", "GET", "HEAD"]
    allowed_origins = ["*"]
    expose_headers  = []
    max_age_seconds = 3000
  }
}
