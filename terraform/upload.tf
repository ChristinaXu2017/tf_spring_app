data "external" "build" {
  program = ["python", "build.py"]
  query = {
    install_command  = var.install-command
    build_command    = var.build-command
    webapp_dir       = var.webapp-dir
    build_destination = var.build-destination

    # front app environment variable
    api_url          = module.app_api.stage_invoke_url
    cdn_url          = "https://${aws_cloudfront_distribution.app_distribution.domain_name}/"

    # front app environment variable from cognito
    cognito_id     = aws_cognito_user_pool.VaccineUserPool.id
    cognito_client = aws_cognito_user_pool_client.VaccineUserPool_client.id    
    cognito_region = var.region
  }
  working_dir = path.module
}

# upload frontend files to aws
resource "null_resource" "app_s3_upload" {
  triggers = {
    compiled_code_hash = data.external.build.result.hash
    build_file_hash    = filesha1("./build.py")
  }

  # we upload to the frontend folder in s3, then we can re-use bucket's other directories for other things
  provisioner "local-exec" {
    command = "aws s3 sync \"${var.build-destination}\" \"s3://${aws_s3_bucket.app_bucket.id}/frontend\" --delete"
  }

  depends_on = [
    aws_s3_bucket.app_bucket
  ]
}

# invalidate caches
resource "null_resource" "cloudfront_invalidate" {
  triggers = {
    compiled_code_hash = data.external.build.result.hash
  }

  provisioner "local-exec" {
    command = "aws cloudfront create-invalidation --distribution-id ${aws_cloudfront_distribution.app_distribution.id} --paths '/*'"
  }

  depends_on = [
    null_resource.app_s3_upload,
  ]
}
