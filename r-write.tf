data "archive_file" "lambdaWrite" {
  type = "zip"

  source_dir  = "${path.module}/lambdaWrite"
  output_path = "${path.module}/artifacts/lambdaWrite.zip"
}

resource "aws_s3_object" "lambda_write_storage" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "artifacts/lambdaWrite.zip"
  source = data.archive_file.lambdaWrite.output_path

  etag = filemd5(data.archive_file.lambdaWrite.output_path)

}

resource "aws_lambda_function" "write" {
  function_name = "write"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_write_storage.key

  runtime = "nodejs12.x"
  handler = "lambdaWrite.handler"

  source_code_hash = data.archive_file.lambdaWrite.output_base64sha256

  role = aws_iam_role.writeRole.arn
}

resource "aws_api_gateway_resource" "writeResource" {
  rest_api_id = aws_api_gateway_rest_api.apiLambda.id
  parent_id   = aws_api_gateway_rest_api.apiLambda.root_resource_id
  path_part   = "writedb"

}

resource "aws_api_gateway_method" "writeMethod" {
  rest_api_id   = aws_api_gateway_rest_api.apiLambda.id
  resource_id   = aws_api_gateway_resource.writeResource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "writeInt" {
  rest_api_id = aws_api_gateway_rest_api.apiLambda.id
  resource_id = aws_api_gateway_resource.writeResource.id
  http_method = aws_api_gateway_method.writeMethod.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.write.invoke_arn

}

resource "aws_lambda_permission" "writePermission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.write.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.apiLambda.execution_arn}/Dev/POST/writedb"
  depends_on = [aws_api_gateway_rest_api.apiLambda, aws_api_gateway_resource.writeResource
  ]

}