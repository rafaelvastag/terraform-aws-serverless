resource "null_resource" "build_lambda_layer" {
  triggers = {
    layer_build = filemd5("${local.layers_path}/package.json")
  }

  provisioner "local-exec" {
    working_dir = local.layers_path
    command     = "npm install --production && cd ../ && zip -9 -r --quiet ${local.layer_name} *"
  }

}

resource "aws_lambda_layer_version" "joi" {
  layer_name          = "joi-layer"
  description         = "joi 17.3.0"
  filename            = "${local.layers_path}/../${local.layer_name}"
  compatible_runtimes = ["nodejs14.x"]

  depends_on = [
  null_resource.build_lambda_layer]
}

resource "aws_lambda_function" "s3" {
  function_name = "s3"
  handler       = "index.handler"
  role          = aws_iam_role.s3.arn
  runtime       = "nodejs14.x"
  filename      = data.archive_file.s3.output_path

  layers = [aws_lambda_layer_version.joi.arn]

  tags = local.common_tags
}

resource "aws_lambda_function" "dynamodb" {
  function_name = "dynamodb"
  handler = "index.handler"
  role          = aws_iam_role.dynamo.arn
  runtime = "nodejs14.x"
  filename = data.archive_file.dynamodb.output_path

  source_code_hash = data.archive_file.dynamodb.output_base64sha256

  timeout = 30
  memory_size = 128

  environment {
    variables = {
      TABLE = aws_dynamodb_table.this.name
    }
  }
}