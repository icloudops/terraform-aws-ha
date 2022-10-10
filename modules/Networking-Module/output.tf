output "vpc_id" {
    value = aws_vpc.vpc.id
}
output "public-subnet-1a_id" {
    value = aws_subnet.public-subnet-1a.id
}
output "public-subnet-1b_id" {
    value = aws_subnet.public-subnet-1b.id
}
output "private-subnet-1a_id" {
    value = aws_subnet.private-subnet-1a.id
}
output "private-subnet-1b_id" {
    value = aws_subnet.private-subnet-1b.id
}