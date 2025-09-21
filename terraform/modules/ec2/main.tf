locals {
  user_data = base64encode(templatefile("${path.module}/scripts/setup.sh", {}))
}

resource "aws_instance" "abiodun_readliner_ec2" {
  ami                         = var.ubuntu_ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  associate_public_ip_address = true

  user_data = local.user_data

  root_block_device {
    volume_type           = var.volume_type
    volume_size           = var.volume_size
    delete_on_termination = true
    encrypted             = var.encrypt_volume

    tags = merge(var.tags, {
      Name = "abiodun-ec2-root-volume"
    })
  }

  monitoring        = var.enable_detailed_monitoring
  source_dest_check = true

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
    instance_metadata_tags      = "enabled"
  }

  tags = merge(var.tags, {
    Name = "abiodun-ec2"
    Type = "Application Server"
  })

  disable_api_termination = false

  lifecycle {
    create_before_destroy = true
  }
}
