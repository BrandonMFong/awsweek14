resource "aws_apigatewayv2_api" "week14-apigw" {
  name                       = "week14-apigw"
  protocol_type              = "HTTP"
  target = "arn:aws:lambda:us-east-1:128928602505:function:week14-lambda"
}

resource "aws_apigatewayv2_integration" "week14-integration" {
  api_id           = aws_apigatewayv2_api.week14-apigw.id
  integration_type = "AWS_PROXY"
  integration_uri = "arn:aws:lambda:us-east-1:128928602505:function:week14-lambda"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "week14-get-route" {
  api_id    = aws_apigatewayv2_api.week14-apigw.id
  route_key = "GET /urls/{id}"

  target = "integrations/${aws_apigatewayv2_integration.week14-integration.id}" 
}

resource "aws_apigatewayv2_route" "week14-post-route" {
  api_id    = aws_apigatewayv2_api.week14-apigw.id
  route_key = "POST /urls"

  target = "integrations/${aws_apigatewayv2_integration.week14-integration.id}" 
}

output "week14-apigw-endpoint" {
  value = aws_apigatewayv2_api.week14-apigw.api_endpoint
}
