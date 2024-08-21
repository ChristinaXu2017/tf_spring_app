terraform {
  backend "s3" {
    # update following as needed
    bucket         = "uts-vaccine-state"
    key            = "example"
    region         = "ap-southeast-2"
    # dynamodb_table = "uts-vaccine-states-table"
  }
}
