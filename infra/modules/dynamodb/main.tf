locals {
  common_tags = merge(var.tags, {
    project = var.project
    env     = var.env
  })

  table_name = coalesce(var.table_name, "${var.project}-${var.env}-metadata")
}

resource "aws_dynamodb_table" "this" {
  name         = local.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "object_key"

  attribute {
    name = "object_key"
    type = "S"
  }

  tags = merge(local.common_tags, {
    Name = local.table_name
  })
}
