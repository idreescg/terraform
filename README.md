# Terraform AWS VPC Project

This Terraform configuration sets up the following resources on AWS:
- A Virtual Private Cloud (VPC)
- Public and private subnets in multiple availability zones
- An Internet Gateway (IGW)
- Route tables and their associations
- An EC2 instance with a key pair
- Security groups to allow SSH and HTTP access

## Prerequisites

- Terraform installed on your local machine.
- AWS CLI configured with your AWS credentials.
- An SSH key pair for EC2 access.

## Terraform Variables

You will need to define the following variables in a `terraform.tfvars` file or as environment variables:

```hcl
vpc_cidr = "10.0.0.0/16"
public_subnet_cidr_2a = "10.0.1.0/24"
public_subnet_cidr_2b = "10.0.2.0/24"
private_subnet_cidr_2c = "10.0.3.0/24"
private_subnet_cidr_2d = "10.0.4.0/24"
aws_key_name = "your_aws_key_name"
