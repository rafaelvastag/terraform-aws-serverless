data "archive_file" "s3" {
  output_path = "files/s3-artefact.zip"
  type        = "zip"
  source_file = "${local.lambdas_path}/s3/index.js"
}

data "archive_file" "dynamodb" {
  output_path = "files/dynamodb-artefact.zip"
  type        = "zip"
  source_file = "${local.lambdas_path}/dynamodb/index.js"
}
