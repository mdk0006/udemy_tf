# Provider AWS
provider "aws" {
  region = "us-east-1"
}
# AWS VPC
resource "aws_vpc" "my_app" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}
# AWS Subnet
resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.my_app.id
  cidr_block = var.subnet_cidr_block
  tags = {
    Name = "${var.env_prefix}-subnet"
  }
}
#AWS IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_app.id
  tags = {
    Name = "${var.env_prefix}-igw"
  }
}
# AWS RT
resource "aws_route_table" "my_app_route_table" {
  vpc_id = aws_vpc.my_app.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.env_prefix}-rtb"
  }
}
#AWS Security Group
resource "aws_security_group" "sg" {
  name   = "${var.env_prefix}-sg"
  vpc_id = aws_vpc.my_app.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0    # for any
    to_port     = 0    #for any
    protocol    = "-1" #for any 
    cidr_blocks = ["0.0.0.0/0"]
    # prefix_list_ids = [] fpr vpc enpoints
  }
  tags = {
    Name = "${var.env_prefix}-sg"
  }
}
