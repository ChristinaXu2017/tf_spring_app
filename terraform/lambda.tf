module "api_lambda_function" {
  source                 = "terraform-aws-modules/lambda/aws"
  function_name          = "${var.app-name}-api"
  description            = "API lambda function"
  handler                = "handler.handler"
  runtime                = "python3.12"
  timeout                = 30
  tags                   = var.tags
  attach_policy_jsons    = true
  number_of_policy_jsons = 3

  source_path = [
    {
      path             = "../backend/lambda/rest-api",
      pip_requirements = true
    }
  ]

  policy_jsons = [
    data.aws_iam_policy_document.app_jobs_s3_access.json,
    data.aws_iam_policy_document.app_lambda_invoke.json,
    data.aws_iam_policy_document.app_dynamodb_access.json
  ]

  environment_variables = {
    S3_BUCKET                   = aws_s3_bucket.app_bucket.id
    DOCKER_LAMBDA_FUNCTION_NAME = module.docker_example_lambda_function.lambda_function_name
    EXAMPLE_TABLE               = aws_dynamodb_table.example_table.name
    REGION                      = var.region
    TIMEOUT                     = 60
  }
}

module "docker_example_lambda_function" {
  source                 = "terraform-aws-modules/lambda/aws"
  source_path            = "../backend/lambda/docker_example"
  function_name          = "docker_example"
  description            = "Run the docker_example tasks."
  create_package         = false
  image_uri              = module.docker_image_docker_example_lambda.image_uri
  package_type           = "Image"
  memory_size            = 4096
  timeout                = 60
  ephemeral_storage_size = 1024
  tags                   = var.tags
  attach_policy_jsons    = true
  number_of_policy_jsons = 2

  policy_jsons = [
    data.aws_iam_policy_document.app_jobs_s3_access.json,
    data.aws_iam_policy_document.app_dynamodb_access.json
  ]

  environment_variables = {
    S3_BUCKET               = aws_s3_bucket.app_bucket.id
    DYNAMO_JOB_STATUS_TABLE = aws_dynamodb_table.example_table.name
    REGION                  = var.region
    TIMEOUT                 = 60
  }
}
