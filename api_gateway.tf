resource "aws_api_gateway_rest_api" "mercury_rest_api" {
  name        = "${var.environment}-mercury-rest-api"
  description = "Mercury Parser REST API"

}

# /parse-html
resource "aws_api_gateway_resource" "mercury_rest_api_parse_html" {
  parent_id   = aws_api_gateway_rest_api.mercury_rest_api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.mercury_rest_api.id
  path_part   = "parse-html"

}


resource "aws_api_gateway_method" "mercury_rest_api_parse_html_options" {
  rest_api_id   = aws_api_gateway_rest_api.mercury_rest_api.id
  resource_id   = aws_api_gateway_resource.mercury_rest_api_parse_html.id
  http_method   = "OPTIONS"
  authorization = "NONE"

}


resource "aws_api_gateway_method" "mercury_rest_api_parse_html_post" {
  rest_api_id      = aws_api_gateway_rest_api.mercury_rest_api.id
  resource_id      = aws_api_gateway_resource.mercury_rest_api_parse_html.id
  http_method      = "POST"
  authorization    = "NONE"
  api_key_required = true

}




#  /parser
resource "aws_api_gateway_resource" "mercury_rest_api_parser" {
  parent_id   = aws_api_gateway_rest_api.mercury_rest_api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.mercury_rest_api.id
  path_part   = "parser"

}

resource "aws_api_gateway_method" "mercury_rest_api_parser_options" {
  rest_api_id   = aws_api_gateway_rest_api.mercury_rest_api.id
  resource_id   = aws_api_gateway_resource.mercury_rest_api_parser.id
  http_method   = "OPTIONS"
  authorization = "NONE"

}


resource "aws_api_gateway_method" "mercury_rest_api_parser_get" {
  rest_api_id      = aws_api_gateway_rest_api.mercury_rest_api.id
  resource_id      = aws_api_gateway_resource.mercury_rest_api_parser.id
  http_method      = "GET"
  authorization    = "NONE"
  api_key_required = true

}

// Options method request
resource "aws_api_gateway_integration" "mercury_rest_api_options_integration" {
  rest_api_id = aws_api_gateway_rest_api.mercury_rest_api.id
  http_method = aws_api_gateway_method.mercury_rest_api_parser_options.http_method
  resource_id = aws_api_gateway_resource.mercury_rest_api_parse_html.id
  type        = "MOCK"
  uri         = module.mercury_lambda_function.lambda_function_invoke_arn

  depends_on = [
    aws_api_gateway_rest_api.mercury_rest_api,
    aws_api_gateway_method.mercury_rest_api_parser_options,
    aws_api_gateway_resource.mercury_rest_api_parse_html
  ]

}

resource "aws_api_gateway_method_response" "mercury_rest_api_options_response_200" {
  rest_api_id = aws_api_gateway_rest_api.mercury_rest_api.id
  resource_id = aws_api_gateway_resource.mercury_rest_api_parse_html.id
  http_method = aws_api_gateway_method.mercury_rest_api_parser_options.http_method
  status_code = 200

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }




}

resource "aws_api_gateway_integration_response" "mercury_rest_api_options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.mercury_rest_api.id
  resource_id = aws_api_gateway_resource.mercury_rest_api_parse_html.id
  http_method = aws_api_gateway_method.mercury_rest_api_parser_options.http_method
  status_code = aws_api_gateway_method_response.mercury_rest_api_options_response_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Amz-User-Agent'"
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [
    aws_api_gateway_method.mercury_rest_api_parser_options
  ]

}


// post
resource "aws_api_gateway_integration" "mercury_rest_api_parse_html_post_integration" {
  rest_api_id             = aws_api_gateway_rest_api.mercury_rest_api.id
  http_method             = aws_api_gateway_method.mercury_rest_api_parse_html_post.http_method
  resource_id             = aws_api_gateway_resource.mercury_rest_api_parse_html.id
  type                    = "AWS_PROXY"
  integration_http_method = "POST"

  uri = module.mercury_lambda_function.lambda_function_invoke_arn


}

// parser
resource "aws_api_gateway_integration" "mercury_rest_api_parser_get_integration" {
  rest_api_id             = aws_api_gateway_rest_api.mercury_rest_api.id
  http_method             = aws_api_gateway_method.mercury_rest_api_parser_get.http_method
  resource_id             = aws_api_gateway_resource.mercury_rest_api_parser.id
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = module.mercury_lambda_function.lambda_function_invoke_arn

}

resource "aws_api_gateway_integration" "mercury_rest_api_parser_options_integration" {
  rest_api_id = aws_api_gateway_rest_api.mercury_rest_api.id
  http_method = aws_api_gateway_method.mercury_rest_api_parser_options.http_method
  resource_id = aws_api_gateway_resource.mercury_rest_api_parser.id
  type        = "MOCK"
  uri         = module.mercury_lambda_function.lambda_function_invoke_arn


}

resource "aws_api_gateway_method_response" "mercury_rest_api_parser_options_method_response" {
  rest_api_id = aws_api_gateway_rest_api.mercury_rest_api.id
  http_method = aws_api_gateway_method.mercury_rest_api_parser_options.http_method
  resource_id = aws_api_gateway_resource.mercury_rest_api_parser.id
  status_code = 200

}


resource "aws_api_gateway_integration_response" "mercury_rest_api_parser_options_method_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.mercury_rest_api.id
  resource_id = aws_api_gateway_resource.mercury_rest_api_parser.id
  http_method = aws_api_gateway_method.mercury_rest_api_parser_options.http_method
  status_code = aws_api_gateway_method_response.mercury_rest_api_parser_options_method_response.status_code

  response_templates = {
    "application/json" = <<EOT
     #set($origin = $input.params("Origin"))
     #if($origin == "") #set($origin = $input.params("origin")) 
     #end
     #if($origin.matches(".+")) #set($context.responseOverride.header.Access-Control-Allow-Origin = $origin) 
     #end
     EOT
  }

  response_parameters = {

  }


}


resource "aws_api_gateway_deployment" "mercury_rest_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.mercury_rest_api.id

  // export TF_VAR_deployed_at=$(date +%s)
  # variables = {
  #   deployed_at = var.deployed_at
  # }
  #


  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.mercury_rest_api.body))
  }

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_api_gateway_stage" "mercury_rest_api_prod_stage" {
  rest_api_id   = aws_api_gateway_rest_api.mercury_rest_api.id
  deployment_id = aws_api_gateway_deployment.mercury_rest_api_deployment.id
  stage_name    = "Prod"

  # access_log_settings {
  #   destination_arn = module.mercury_rest_api_access_log_group.cloudwatch_log_group_arn
  #
  #   format = jsonencode(
  #     {
  #       caller                  = "$context.identity.caller"
  #       httpMethod              = "$context.httpMethod"
  #       ip                      = "$context.identity.sourceIp"
  #       protocol                = "$context.protocol"
  #       requestId               = "$context.requestId"
  #       requestTime             = "$context.requestTime"
  #       resourcePath            = "$context.resourcePath"
  #       responseLength          = "$context.responseLength"
  #       status                  = "$context.status"
  #       user                    = "$context.identity.user"
  #       message                 = "$context.error.message"
  #       error                   = "$context.integration.error"
  #       integrationstatus       = "$context.integration.status"
  #       integrationErrorMessage = "$context.integrationErrorMessage"
  #     }
  #   )
  # }


}



// API KEY
resource "aws_api_gateway_api_key" "mercury_rest_api_api_key" {
  name = "${var.environment} mercury rest api API Key"

}


// Usage plan
resource "aws_api_gateway_usage_plan" "mercury_rest_api_usage_plan" {
  name        = "${var.environment}-mercury-client"
  description = "Mercury API Usage Plan"

  api_stages {
    api_id = aws_api_gateway_rest_api.mercury_rest_api.id
    stage  = aws_api_gateway_stage.mercury_rest_api_prod_stage.stage_name
  }


  quota_settings {
    limit  = 10000
    offset = 0
    period = "MONTH"
  }

  throttle_settings {
    burst_limit = 30
    rate_limit  = 60
  }
}

resource "aws_api_gateway_usage_plan_key" "mercury_rest_api_plan_key" {
  key_id        = aws_api_gateway_api_key.mercury_rest_api_api_key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.mercury_rest_api_usage_plan.id
}


// Mercury API Access Log
module "mercury_rest_api_access_log_group" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/log-group"
  version = "3.0.0"

  name              = "mercury_rest_api_access_log_group_${random_id.random_id.hex}"
  retention_in_days = 7




}

# resource "aws_api_gateway_domain_name" "mercury_parser_api_domain" {
#   domain_name              = "parser.reca.st"
#   regional_certificate_arn = var.recast_ssl_cert_arn
#
#   endpoint_configuration {
#     types = ["REGIONAL"]
#   }
#
# }
#
# resource "aws_api_gateway_base_path_mapping" "mercury_parser_rest_api_prod_stage_mapping" {
#   api_id      = aws_api_gateway_rest_api.mercury_rest_api.id
#   stage_name  = aws_api_gateway_stage.mercury_rest_api_prod_stage.stage_name
#   domain_name = aws_api_gateway_domain_name.mercury_parser_api_domain.domain_name
#
# }


