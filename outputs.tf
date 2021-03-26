output "vpc_id" {
    value = aws_vpc.my_app.id
}
output "subnet_id" {
    value= aws_subnet.subnet-1.id
}
/*output "rt-id" {
    value = aws_route_table.my_app_route_table.id
}
*/
output "igw-id" {
    value = aws_internet_gateway.igw.id
}