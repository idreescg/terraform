resource "aws_vpc" "my_vpc_01" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  
}

#creating the IGW
resource "aws_internet_gateway" "myvpc" {
  vpc_id = aws_vpc.my_vpc_01.id
}

#--------------------------------------------Start of Public Subnet Block----------------------------------------
#Creation of Public Subnet
resource "aws_subnet" "public_subnet_us-west-2a" {
  vpc_id = aws_vpc.my_vpc_01.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = "us-west-2a"
  tags = {
     Name = "Public Subnet"
     AZ = "us-west-2a"
         }
}

#Creation of Routetable for public subnet
resource "aws_route_table" "public_rt_us-west-2a" {
  vpc_id = aws_vpc.my_vpc_01.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myvpc.id # this has internet access 
  } 
  tags = {
    "Name" = "Public RT"
  }
}

#Association of RT to public subnet
resource "aws_route_table_association" "associate_public_rt" {
  subnet_id      = aws_subnet.public_subnet_us-west-2a.id
  route_table_id = aws_route_table.public_rt_us-west-2a.id
}

#--------------------------------------------End of Public Subnet Block----------------------------------------

#--------------------------------------------Start of Private Subnet Block-------------------------------------

#Creation of Private Subnet
resource "aws_subnet" "private_subnet_us-west-2b" {
  vpc_id = aws_vpc.my_vpc_01.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = "us-west-2b"
  tags = {
     Name = "Private Subnet"
     AZ = "us-west-2b"
         }
}

#Creation of Routetable for private subnet
resource "aws_route_table" "private_rt_us-west-2b" {
  vpc_id = aws_vpc.my_vpc_01.id
  tags = {
    "Name" = "Private RT"
  }
  
}

#Association of RT to private subnet
resource "aws_route_table_association" "associate_private_rt" {
  subnet_id      = aws_subnet.private_subnet_us-west-2b.id
  route_table_id = aws_route_table.private_rt_us-west-2b.id
}

#--------------------------------------------End of Private Subnet Block-------------------------------------
