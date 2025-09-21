output "vpc_id" {
  description = "VPC ID"
  value       = data.aws_vpc.main.id
}

output "subnet_id" {
  description = "Subnet ID"
  value       = aws_subnet.abiodun_subnet.id
}

output "security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.abiodun_sg.id
}

output "instance_id" {
  description = "EC2 instance ID"
  value       = module.ec2.instance_id
}

output "instance_public_ip" {
  description = "EC2 public IP"
  value       = module.ec2.public_ip
}

output "instance_private_ip" {
  description = "EC2 private IP"
  value       = module.ec2.private_ip
}

output "instance_public_dns" {
  description = "EC2 public DNS"
  value       = module.ec2.public_dns
}

output "application_url" {
  description = "Flask app URL"
  value       = "http://${module.ec2.public_ip}:8080"
}

output "ssh_connection_command" {
  description = "SSH command"
  value       = "ssh -i ~/.ssh/${var.key_name}.pem ec2-user@${module.ec2.public_ip}"
}
