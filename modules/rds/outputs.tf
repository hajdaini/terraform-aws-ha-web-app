output "host" {
  value = aws_db_instance.mariadb.address
}

output "username" {
  value = aws_db_instance.mariadb.username
}