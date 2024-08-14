provider "docker" {
  registry_auth {
    address  = format("%v.dkr.ecr.%v.amazonaws.com", data.aws_caller_identity.this.account_id, var.region)
    username = data.aws_ecr_authorization_token.token.user_name
    password = data.aws_ecr_authorization_token.token.password
  }
}

# docker_example lambda function
data "external" "docker_example_lambda_source_hash" {
  program     = ["python", "../backend/lambda/docker_example/docker_prep.py"]
  working_dir = path.module
}

module "docker_image_docker_example_lambda" {
  source = "terraform-aws-modules/lambda/aws//modules/docker-build"

  create_ecr_repo = true
  ecr_repo        = "docker_example-lambda-containers"
  ecr_repo_lifecycle_policy = jsonencode({
    "rules" : [
      {
        "rulePriority" : 1,
        "description" : "Keep only the last 1 images",
        "selection" : {
          "tagStatus" : "any",
          "countType" : "imageCountMoreThan",
          "countNumber" : 1
        },
        "action" : {
          "type" : "expire"
        }
      }
    ]
  })
  use_image_tag = false
  source_path   = "../backend/lambda/docker_example"

  triggers = {
    dir_sha = data.external.docker_example_lambda_source_hash.result.hash
  }
}
