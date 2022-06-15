# Input variable definitions

variable "aws_region" {
  description = "AWS region for all resources."

  type    = string
  default = "us-east-1"
}


variable "access_key" {
  description = "This specifies the access key"
  type        = string
}

variable "secret_key" {
  description = "This specifies the secret key"
  type        = string
}


variable "tags" {
  description = "Tags for resources"
  type        = map(any)
  default = {
    environment = "Development"
  }
}