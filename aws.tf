provider "aws" {
  access_key = var.aws_access_key #values are inside the terraform.tfvars
  secret_key = var.aws_secret_key #values are inside the terraform.tvfars
  region     = var.aws_region
}