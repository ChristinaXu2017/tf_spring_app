module "app_api" {
  source = "terraform-aws-modules/apigateway-v2/aws"

  name          = "${var.app-name}-http-api"
  description   = "${var.app-name} HTTP API Gateway"
  protocol_type = "HTTP"

  create_domain_name = false
  create_certificate = false

  cors_configuration = {
    allow_headers  = ["*"]
    allow_methods  = ["*"]
    allow_origins  = ["*"]
    expose_headers = ["*"]
    max_age        = 3600
  }

  # Routes & Integration(s)
  routes = {
    "ANY /{proxy+}" = {
      integration = {
        uri = module.start_jupyter_lambda_function.lambda_function_invoke_arn
        payload_format_version = "2.0"
      }
    }
  }
}

resource "aws_lambda_permission" "vaccine_rest_api_lambda_permissions" {
  statement_id  = "${var.app-name}_rest_api_lambda_permissions"
  action        = "lambda:InvokeFunction"
  function_name = module.start_jupyter_lambda_function.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${module.app_api.api_execution_arn}/**"
}

# API Gateway v1 (REST API) for login
resource "aws_api_gateway_rest_api" "VaccineApi" {
  name        = "VaccineApi"
  description = "API for Vaccine Application"
}


resource "aws_api_gateway_authorizer" "VaccineUserPoolAuthorizer" {
  name          = "VaccineUserPoolAuthorizer"
  type          = "COGNITO_USER_POOLS"
  rest_api_id   = aws_api_gateway_rest_api.VaccineApi.id
  provider_arns = [aws_cognito_user_pool.VaccineUserPool.arn]

  depends_on = [aws_api_gateway_rest_api.VaccineApi]
}