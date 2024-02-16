output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "gw_id" {
  value = aws_internet_gateway.igw.id
}

output "rt_id" {
  value = aws_route_table.rt.id
}
