variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-3"
}

variable "vpc_id" {
  description = "Existing VPC ID"
  type        = string
}

variable "internet_gateway_id" {
  description = "Existing Internet Gateway ID"
  type        = string
}

variable "subnet_cidr" {
  description = "Subnet CIDR block"
  type        = string
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "allowed_ssh_cidrs" {
  description = "CIDR blocks allowed for SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "environment" {
  description = "Environment (dev/staging/prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "Qucoon-Lab"
}

variable "owner" {
  description = "Owner"
  type        = string
  default     = "Abiodun"
}

variable "ubuntu_ami_id" {
  description = "AMI ID of the Ubuntu image to use for the EC2 instance"
  type        = string
}
