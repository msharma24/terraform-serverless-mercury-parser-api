module "mercury_lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "2.35.1"

  function_name = "${var.environment}-mercury-html-parser"
  description   = "Mercury Parser"
  handler       = "src/parse-html.default"
  runtime       = "nodejs12.x"

  memory_size = "256"
  timeout     = "10"

  create_package         = false
  local_existing_package = "./mercury-parser-api/.webpack/mercury.zip"


  lambda_role = module.recast_lambda_iam_assumable_role.iam_role_arn


  tags = {
    Name = "${var.environment}-mercury-Lambda"
  }


}

# # Lambda Permission
resource "aws_lambda_permission" "mercury_parser_apigw_lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.mercury_lambda_function.lambda_function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${local.region}:${local.account_id}:${aws_api_gateway_rest_api.mercury_rest_api.id}/*/${aws_api_gateway_method.mercury_rest_api_parser_get.http_method}${aws_api_gateway_resource.mercury_rest_api_parser.path}"
}

# module "lambda-cloudwatch-trigger" {
#   source                = "infrablocks/lambda-cloudwatch-events-trigger/aws"
#   version               = "1.1.0-rc.3"
#   region                = var.aws_region
#   component             = "mercury-Lambda"
#   deployment_identifier = "production"
#
#   lambda_arn                 = module.mercury_lambda_function.lambda_function_arn
#   lambda_function_name       = module.mercury_lambda_function.lambda_function_name
#   lambda_schedule_expression = "rate(5 minutes)"
# }

resource "aws_lambda_permission" "mercury_parser_apigw_lambda_permission_2" {
  statement_id  = "AllowExecutionFromAPIGateway2"
  action        = "lambda:InvokeFunction"
  function_name = module.mercury_lambda_function.lambda_function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${local.region}:${local.account_id}:${aws_api_gateway_rest_api.mercury_rest_api.id}/*/${aws_api_gateway_method.mercury_rest_api_parse_html_post.http_method}${aws_api_gateway_resource.mercury_rest_api_parse_html.path}"
}
