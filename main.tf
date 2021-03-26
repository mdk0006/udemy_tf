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
/*resource "aws_route_table" "my_app_route_table" {
  vpc_id = aws_vpc.my_app.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.env_prefix}-rtb"
  }
}
*/
/*AWS RT Association
resource "aws_route_table_association" "a-rt" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.my_app_route_table.id
}
*/

resource "aws_default_route_table" "main-rtb" {
  default_route_table_id = aws_vpc.my_app.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.env_prefix}-main-rtb"
  }
}