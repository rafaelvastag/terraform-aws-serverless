resource "aws_api_gateway_rest_api" "this" {
  name = var.service_name
}

resource "aws_api_gateway_resource" "v1" {
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "v1"
  rest_api_id = aws_api_gateway_rest_api.this.id
}

resource "aws_api_gateway_resource" "todos" {
  parent_id   = aws_api_gateway_resource.v1.id
  path_part   = "todos"
  rest_api_id = aws_api_gateway_rest_api.this.id
}

resource "aws_api_gateway_authorizer" "this" {
  name          = "CognitoUserPoolAuthorizer"
  rest_api_id   = aws_api_gateway_rest_api.this.id
  type          = "COGNITO_USER_POOLS"
  provider_arns = [aws_cognito_user_pool.this.arn]
}

resource "aws_api_gateway_method" "any" {
  authorization = "COGNITO_USER_POOLS"
  http_method   = "ANY"
  resource_id   = aws_api_gateway_resource.todos.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
  authorizer_id = aws_api_gateway_authorizer.this.id
}

resource "aws_api_gateway_integration" "this" {
  http_method             = aws_api_gateway_method.any.http_method
  resource_id             = aws_api_gateway_resource.todos.id
  rest_api_id             = aws_api_gateway_rest_api.this.id
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.dynamodb.invoke_arn
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  stage_name  = "dev"

  depends_on = [aws_api_gateway_integration.this]
}