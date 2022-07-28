resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "Users"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  # attribute {
  #   name = "fullName"
  #   type = "S"
  # }


  # ttl {
  #   attribute_name = "DateCreated"
  #   enabled        = true
  # }

  # tags = var.tags
}