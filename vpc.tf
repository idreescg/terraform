resource "aws_vpc" "my_vpc_01" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  
}

#creating the IGW
resource "aws_internet_gateway" "myvpc" {
  vpc_id = aws_vpc.default.id
}

#Creation of Public Subnet
resource "aws_subnet" "public_subnet_us-west-2a" {
  vpc_id = aws_vpc.default.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = "us-west-2a"
}

#Creation of Routetable for public subnet
resource "aws_route_table" "public_rt_us-west-2a" {
  vpc_id = aws_vpc.default.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id # this has internet access 
  } 
}

#Association of RT to public subnet
resource "aws_route_table_association" "associate_public_rt" {
  subnet_id      = aws_subnet.public_subnet_us-west-2a.id
  route_table_id = aws_route_table.public_rt_us-west-2a.id
}
