output "mercury_rest_api" {
  value = aws_api_gateway_rest_api.mercury_rest_api.arn

}

output "lambda_function_name" {
  value = module.mercury_lambda_function.lambda_function_name

}
