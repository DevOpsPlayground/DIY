resource "aws_dynamodb_table" "playground_table" {
  name         = var.name
  hash_key     = var.hashKey
  billing_mode = var.billingMode
  attribute {
    type = "S"
    name = var.hashKey
  }
  tags = {
    "Name" = "${var.PlaygroundName}-${var.name}-table"
  }
}

