output "vpc_name" {
  value = aws_vpc.my_app.tags.Name
}
/*output "subnet_name" {
  value = aws_subnet.subnet-1.tags.Name
}
output "rt-name" {
  value = aws_route_table.my_app_route_table.tags.Name
}
output "igw-name" {
  value = aws_internet_gateway.igw.tags.Name
}*/
output "sg-name" {
  value = aws_security_group.sg.name
}
output "aws_ami_id" {
  value = data.aws_ami.latest_amazon_linux_ami.id
}
output "instance_public_ip" {
  value = aws_instance.ec2.public_ip
}