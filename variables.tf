#setting the aws region
variable "aws_region" {
  description = "Region for all the services- Oregon"
  default     = "us-west-2"
}

variable "aws_access_key" {}
  
variable "aws_secret_key" {}



#VPC Cidr range 
variable "vpc_cidr" {
  description = "CIDR for VPC"
  default     = "10.0.0.0/16"
}

#Public Subnet CIDR range
variable "public_subnet_cidr_2a" {
  default     = "10.0.0.0/24"
}


variable "public_subnet_cidr_2b" {
  default     = "10.0.1.0/24"
}

#Private Subnet CIDR range
variable "private_subnet_cidr_2c" {
  default     = "10.0.2.0/24"
}

#Private Subnet CIDR range
variable "private_subnet_cidr_2d" {
  default     = "10.0.3.0/24"
}
