module "start_jupyter_lambda_function" {
  source                 = "terraform-aws-modules/lambda/aws"
  function_name          = "start_jupyter"
  description            = "API lambda function to trigger jupyter notebook"
  handler                = "start_jupyter.lambda_handler"
  runtime                = "python3.8"
  timeout                = 60
  tags                   = { "Project" = "vaccine" }
  attach_policy_jsons    = true
  source_path = "../backend/lambda/jupyter"

  policy_jsons = [
    data.aws_iam_policy_document.app_jobs_s3_access.json,
    data.aws_iam_policy_document.app_dynamodb_access.json
  ]

  environment_variables = {
    BUCKET                   = aws_s3_bucket.app_bucket.id
    DYTABLE               = aws_dynamodb_table.example_table.name
    REGION                      = var.region

    ECR_REPO = module.docker_jupyter_register.image_uri
    HASH_JUPYTER_PW = var.jupyter_pw
    SECURITY_GROUP = aws_security_group.uts_app_sg.id
    EC2IAM = aws_iam_instance_profile.ec2_profile.arn  
    # this key name is just for debug"
    KEY_NAME = "2nd_KeyPair"
  }
}

module "stop_jupyter_lambda_function" {
  source                 = "terraform-aws-modules/lambda/aws"
  function_name          = "stop_jupyter"
  description            = "API lambda function to stop jupyter notebook"
  handler                = "stop_jupyter.lambda_handler"
  runtime                = "python3.8"
  timeout                = 60
  tags                   = { "Project" = "vaccine" }
  attach_policy_jsons    = true
  source_path = "../backend/lambda/jupyter"

  policy_jsons = [
    data.aws_iam_policy_document.app_dynamodb_access.json
  ]

  environment_variables = {
    DYTABLE               = aws_dynamodb_table.example_table.name
  }
}