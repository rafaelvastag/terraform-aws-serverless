locals {
  lambdas_path = "${path.module}/../app/lambdas"
  layers_path  = "${path.module}/../app/layers/nodejs"
  layer_name   = "joi.zip"

  common_tags = {
    Project   = "TODO Serverless App"
    CreatedAt = timestamp()
    ManagedBy = "Terraform"
    Owner     = "Rafael Vastag"
    Service   = var.service_name
  }
}