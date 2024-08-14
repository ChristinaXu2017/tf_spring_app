terraform {
  backend "s3" {
    # update following as needed
    bucket         = "my-terraform-states-bucket"
    key            = "example"
    region         = "ap-southeast-2"
    dynamodb_table = "my-terraform-states-table"
  }
}