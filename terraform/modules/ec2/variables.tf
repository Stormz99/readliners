variable "ubuntu_ami_id" {
  description = "AMI ID of the Ubuntu image to use for the EC2 instance"
  type        = string
  validation {
    condition     = can(regex("^ami-[0-9a-f]{8,17}$", var.ubuntu_ami_id))
    error_message = "AMI ID must be a valid AWS AMI identifier."
  }
}

variable "subnet_id" {
  description = "ID of the subnet where the EC2 instance will be launched"
  type        = string
  validation {
    condition     = can(regex("^subnet-[0-9a-f]{8,17}$", var.subnet_id))
    error_message = "Subnet ID must be a valid subnet identifier."
  }
}

variable "security_group_id" {
  description = "ID of the security group to associate with the EC2 instance"
  type        = string
  validation {
    condition     = can(regex("^sg-[0-9a-f]{8,17}$", var.security_group_id))
    error_message = "Security group ID must be a valid security group identifier."
  }
}

variable "key_name" {
  description = "Name of the AWS Key Pair for EC2 instance access"
  type        = string
  validation {
    condition     = length(var.key_name) > 0
    error_message = "Key pair name cannot be empty."
  }
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
  validation {
    condition = contains([
      "t3.nano", "t3.micro", "t3.small", "t3.medium", "t3.large", "t3.xlarge",
      "t2.nano", "t2.micro", "t2.small", "t2.medium", "t2.large", "t2.xlarge"
    ], var.instance_type)
    error_message = "Instance type must be a valid t3 or t2 instance type."
  }
}

variable "tags" {
  description = "Tags to apply to the EC2 instance and related resources"
  type        = map(string)
  default     = {}
}

variable "enable_detailed_monitoring" {
  description = "Enable detailed monitoring for the EC2 instance (incurs additional charges)"
  type        = bool
  default     = false
}

variable "volume_size" {
  description = "Size of the root volume in GB"
  type        = number
  default     = 8
  validation {
    condition     = var.volume_size >= 8 && var.volume_size <= 100
    error_message = "Volume size must be between 8 and 100 GB."
  }
}

variable "volume_type" {
  description = "Type of the root volume"
  type        = string
  default     = "gp3"
  validation {
    condition     = contains(["gp2", "gp3", "io1", "io2"], var.volume_type)
    error_message = "Volume type must be one of: gp2, gp3, io1, io2."
  }
}

variable "encrypt_volume" {
  description = "Enable encryption for the root volume"
  type        = bool
  default     = true
}
