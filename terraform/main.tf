terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# Data sources for existing resources
data "aws_vpc" "main" {
  id = var.vpc_id
}

data "aws_internet_gateway" "main" {
  internet_gateway_id = var.internet_gateway_id
}

# Get availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Subnet
resource "aws_subnet" "abiodun_subnet" {
  vpc_id                  = data.aws_vpc.main.id
  cidr_block              = var.subnet_cidr
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.owner}-subnet"
    Owner       = var.owner
    Project     = var.project_name
    Environment = var.environment
    Terraform   = "true"
  }
}

# Route table
resource "aws_route_table" "abiodun_rt" {
  vpc_id = data.aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.main.id
  }

  tags = {
    Name        = "${var.owner}-route-table"
    Owner       = var.owner
    Project     = var.project_name
    Environment = var.environment
    Terraform   = "true"
  }
}

# Route table association
resource "aws_route_table_association" "abiodun_rta" {
  subnet_id      = aws_subnet.abiodun_subnet.id
  route_table_id = aws_route_table.abiodun_rt.id
}

# Security group
resource "aws_security_group" "abiodun_sg" {
  name_prefix = "${var.owner}-sg-"
  description = "Security group for ${var.owner}s EC2"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidrs
  }

  ingress {
    description = "Flask App"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS (secure connections)"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.owner}-sg"
    Owner       = var.owner
    Project     = var.project_name
    Environment = var.environment
    Terraform   = "true"
  }
}

# SSH Key Pair
resource "aws_key_pair" "abiodun" {
  key_name   = var.key_name
  public_key = file(pathexpand("~/.ssh/abiodun-readliner-keypair.pub"))
}

# EC2 Instance module
module "ec2" {
  source = "./modules/ec2"

  subnet_id         = aws_subnet.abiodun_subnet.id
  security_group_id = aws_security_group.abiodun_sg.id
  key_name          = aws_key_pair.abiodun.key_name
  instance_type     = var.instance_type
  ubuntu_ami_id     = var.ubuntu_ami_id

  tags = {
    Owner       = var.owner
    Project     = var.project_name
    Environment = var.environment
    Terraform   = "true"
  }
}
