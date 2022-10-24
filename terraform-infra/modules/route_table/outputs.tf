output "igw_id" {
    value = aws_internet_gateway.opstree_igw.id
}

output "natgw_id" {
    value = aws_nat_gateway.opstree_natgw.id
}

output "route_table_ids" {
    value = aws_route_table.opstree_route_table.*.id
}

output "public_route_table_id" {
    value = data.aws_route_table.public_route_table_id.id
}

output "private_route_table_id" {
    value = data.aws_route_table.private_route_table_id.id
}
