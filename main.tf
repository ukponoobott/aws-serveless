resource "random_pet" "lambda_bucket_name" {
  prefix = "lambda-functions-storage"
  length = 4
}

resource "aws_s3_bucket" "lambda_bucket" { 
  bucket = random_pet.lambda_bucket_name.id

  acl           = "private"
  force_destroy = true
  tags          = var.tags
}

resource "aws_api_gateway_rest_api" "apiLambda" {
  name = "testAPI"
}

resource "aws_api_gateway_deployment" "apideploy" {
  depends_on = [aws_api_gateway_integration.writeInt, aws_api_gateway_integration.readInt,
  aws_api_gateway_integration.updateInt, aws_api_gateway_integration.deleteInt]

  rest_api_id = aws_api_gateway_rest_api.apiLambda.id
  stage_name  = "Dev"
}