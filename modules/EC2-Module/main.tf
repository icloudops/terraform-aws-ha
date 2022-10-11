####create key
resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2_key" {
  key_name   = "${var.project_name}-ec2-key"
  public_key = trimspace(tls_private_key.ec2_key.public_key_openssh)
}
resource "aws_ssm_parameter" "ec2_ssm_private_key" {
  name        = "${var.project_name}-ec2-key"
  description = "${var.project_name}-ec2-private-key"
  type        = "SecureString"
  value       = trimspace(tls_private_key.ec2_key.private_key_openssh)
}
#####Security Group
resource "aws_security_group" "default_sg" {
  name        = "allow_http"
  description = "Allow http inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "Allow_HTTP_From_All"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    # cidr_blocks      = [var.vpc_cidr]
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}_default_sg"
  }
}
#get ubuntu 2022 id
data "aws_ami_ids" "ami" {
  owners = ["amazon","aws-marketplace"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

##### Create Launch Configuration Template
resource "aws_launch_template" "ec2_template" {
  name = "${var.project_name}-ec2-template"

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = var.ebs_size
    }
  }


  credit_specification {
    cpu_credits = "unlimited"
  }

#   disable_api_stop        = true
#   disable_api_termination = true

  ebs_optimized = true

#   iam_instance_profile {
#     name = "test"
#   }

  image_id = data.aws_ami_ids.ami.ids[0]

  instance_initiated_shutdown_behavior = "terminate"

  instance_type = var.instance_type

  key_name = aws_key_pair.ec2_key.key_name

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  monitoring {
    enabled = true
  }

  vpc_security_group_ids = [aws_security_group.default_sg.id]
  
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "ha-ec2-template"
    }
  }

  user_data = filebase64("${path.module}/setup.sh")
}