output "subnet-1" {
  value = aws_subnet.dev-subnet.id
}
output "subnet-2" {
  value = aws_subnet.tf_subnet.id
}
output "vpc_id" {
  value = aws_vpc.my-vpc.id
}
