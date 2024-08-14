resource "aws_dynamodb_table" "example_table" {
  billing_mode = "PAY_PER_REQUEST"
  name         = "Example"
  hash_key     = "Id"

  attribute {
    name = "Id"
    type = "S"
  }
}
