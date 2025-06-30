output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.web_server.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.web_server.public_ip
}

output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.web_server.private_ip
}

output "instance_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.web_server.public_dns
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.web_sg.id
}

output "elastic_ip" {
  description = "Elastic IP address (if created)"
  value       = var.create_elastic_ip ? aws_eip.web_eip[0].public_ip : null
}

output "website_url" {
  description = "URL to access the web application"
  value       = var.create_elastic_ip ? "http://${aws_eip.web_eip[0].public_ip}" : "http://${aws_instance.web_server.public_ip}"
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = var.key_pair_name != null ? "ssh -i ~/.ssh/${var.key_pair_name}.pem ec2-user@${aws_instance.web_server.public_ip}" : "No key pair specified - SSH not available"
}

output "instance_tags" {
  description = "Tags applied to the instance"
  value       = aws_instance.web_server.tags
}

output "deployment_summary" {
  description = "Summary of the deployment"
  value = {
    project_name    = var.project_name
    environment     = var.environment
    region          = var.aws_region
    instance_type   = var.instance_type
    instance_id     = aws_instance.web_server.id
    public_ip       = aws_instance.web_server.public_ip
    security_group  = aws_security_group.web_sg.id
    elastic_ip      = var.create_elastic_ip ? aws_eip.web_eip[0].public_ip : null
    website_url     = var.create_elastic_ip ? "http://${aws_eip.web_eip[0].public_ip}" : "http://${aws_instance.web_server.public_ip}"
  }
}