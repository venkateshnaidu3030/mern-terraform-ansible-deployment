output "web_server_public_ip" {
  description = "Public IP of the Web Server"
  value       = aws_instance.web_server.public_ip
}

output "web_server_private_ip" {
  description = "Private IP of the Web Server"
  value       = aws_instance.web_server.private_ip
}

output "db_server_private_ip" {
  description = "Private IP of the DB Server"
  value       = aws_instance.db_server.private_ip
}
