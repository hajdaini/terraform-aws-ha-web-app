output "vpc_id" {
  value = aws_vpc.main.id
}

output "private_subnet_ids" {
  value = [for private_subnet in aws_subnet.main-private : private_subnet.id]
}

output "public_subnet_ids" {
  value = [for public_subnet in aws_subnet.main-public : public_subnet.id]
}