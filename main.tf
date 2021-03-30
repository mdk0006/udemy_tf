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
  vpc_id            = aws_vpc.my_app.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.avail_zone
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
  name   = "my_sg"
  vpc_id = aws_vpc.my_app.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
#AWS Data For AMI's
data "aws_ami" "latest_amazon_linux_ami" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
# AWS Keypair
resource "aws_key_pair" "my-key" {
  key_name = "my-key"
  ##  ssh-keygen -f tf_ec2_key
  public_key = file("tf_ec2.pub")

}
#AWS Instance
resource "aws_instance" "ec2" {
  count                       = 3
  ami                         = data.aws_ami.latest_amazon_linux_ami.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.subnet-1.id
  vpc_security_group_ids      = [aws_security_group.sg.id]
  availability_zone           = var.avail_zone
  associate_public_ip_address = true
  key_name                    = aws_key_pair.my-key.key_name
  user_data                   = file("script.sh")
  tags = {
    Name = "${var.env_prefix}-ec2"
  }

}
#AWS Route Table Association
resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.my_app_route_table.id
}