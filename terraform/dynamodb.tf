resource "aws_dynamodb_table" "this" {
  name           = var.service_name
  hash_key       = "TodoId"
  read_capacity  = 5
  write_capacity = 5
  attribute {
    name = "TodoId"
    type = "S"
  }
  tags = local.common_tags
}

resource "aws_dynamodb_table_item" "this" {
  hash_key   = aws_dynamodb_table.this.hash_key
  table_name = aws_dynamodb_table.this.name
  item       = <<ITEM
{
  "TodoId" : {"S" : "1"},
  "Task": { "S": "Learning Terraform"},
  "Done" : {"S" : "0"}
}
ITEM
}