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

#--------------------------------------------Creation of ec2 instance with public Subnet---------------------
resource "aws_instance" "web_instance" {
  ami           = "ami-0f1a5f5ada0e7da53"
  instance_type = "t2.micro"
  key_name      = "Myec2Keypair"

  subnet_id                   = aws_subnet.public_subnet_us-west-2a.id
  vpc_security_group_ids      = [aws_security_group.sg_webserver.id]
  associate_public_ip_address = true

  user_data = <<-EOF
  #!/bin/bash -ex

  amazon-linux-extras install nginx1 -y
  systemctl enable nginx
  systemctl start nginx
  EOF

  tags = {
    "Name" : "MyterraformEc2"
  }
}


#---------------------------Security Group ----------------------------------------

resource "aws_security_group" "sg_webserver" {
  name   = "Allowing http and SSH access from internet"
  vpc_id = aws_vpc.my_vpc_01.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}