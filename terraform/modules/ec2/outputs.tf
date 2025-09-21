output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.abiodun_readliner_ec2.id
}

output "instance_arn" {
  description = "ARN of the EC2 instance"
  value       = aws_instance.abiodun_readliner_ec2.arn
}

output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.abiodun_readliner_ec2.public_ip
}

output "private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.abiodun_readliner_ec2.private_ip
}

output "public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.abiodun_readliner_ec2.public_dns
}

output "private_dns" {
  description = "Private DNS name of the EC2 instance"
  value       = aws_instance.abiodun_readliner_ec2.private_dns
}

output "availability_zone" {
  description = "Availability zone of the EC2 instance"
  value       = aws_instance.abiodun_readliner_ec2.availability_zone
}

output "ami_id" {
  description = "AMI ID used for the EC2 instance"
  value       = aws_instance.abiodun_readliner_ec2.ami
}

output "instance_state" {
  description = "State of the EC2 instance"
  value       = aws_instance.abiodun_readliner_ec2.instance_state
}

output "security_groups" {
  description = "Security groups associated with the EC2 instance"
  value       = aws_instance.abiodun_readliner_ec2.vpc_security_group_ids
}

output "key_name" {
  description = "Key pair name used for the EC2 instance"
  value       = aws_instance.abiodun_readliner_ec2.key_name
}
