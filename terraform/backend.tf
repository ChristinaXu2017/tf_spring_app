terraform {
  backend "s3" {
    # update following as needed
    bucket         = "terraform-states-testing-deployments"
    key            = "example"
    region         = "ap-southeast-2"
    dynamodb_table = "terraform-states-testing-deployments"
  }
}