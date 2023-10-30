data "aws_ami" "ubuntu20" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}
resource "aws_key_pair" "ansible" {
  key_name   = "ansible"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCho9T7zmSD4t0LzBubwHJ0vdBmQ/6HS+Kztcum0IAP+Gbdvjwol6626i/OhwoaERsR6TElLNIvuP/RShvkNzWTaHr6pc3WC9dyodoC1j9xGiw6+R/7AzmGLweAdtpmtndxMZsvBSDs9AOfMbq49O0zFZVbKazyUJpm/S+uXUpoWjPNUAzgLnYUsppLZSb8aPgdlIRuVKNvKPLHpUc/nwqWs51Fps1KFnD710X1L5p64f3u1GueF0MM8X5nm2qmpKku/ZGQDmQdG7YvIb5eX/N5Tw/0QVrIr2TYxZXzM1qd/ev4FtqkbTEDSBrlDvSmsfPUD2tN2S+K8DnMQI+3pr81ueqF/G29xhp2y/3Xxb2Lv5hvD9L7IRs/AvNLVC0vaFlihhF7uZGQe717ps7vq0MgCc95COPUY564pVtTkAYLUyFoSO3m/dLU8ZbscOUxnSN7DaTlL6izzYdgcvMYciF77uqbvixMEg+Q4lmbaqxWgL/hY5CIgaVb5oEH3XNOmX0="
}

#Creating EC2 instance
resource "aws_instance" "main" {
  for_each               = var.instance
  ami                    = data.aws_ami.ubuntu20.id
  instance_type          = each.value.instance_type
  key_name               = aws_key_pair.ansible.key_name
  vpc_security_group_ids = [aws_security_group.base.id]
  tags                   = {
    Name        = each.value.name
    Environment = each.value.env
    DC          = var.short_region
    Role        = each.value.name
  }
  volume_tags = {
    Name        = "${each.value.name} volume"
    Environment = each.value.env
    Role        = "${each.value.name} volume"
    DC          = var.short_region
  }
  metadata_options {
    http_endpoint = "enabled"
    http_tokens = "required"
  }
  root_block_device {
    volume_size = each.value.size_volume
    volume_type = "gp3"
    throughput = "125"
    encrypted = false #tfsec:ignore:aws-ec2-enable-at-rest-encryption
  }
  lifecycle {
    ignore_changes  = ["ami"]
  }
}
resource "aws_ec2_instance_state" "instance_state" {
  for_each    = var.instance
  instance_id = aws_instance.main[each.value.name].id
  state       = each.value.state
}
#================== Security group and VPC ==================#
data "aws_vpc" "primary" {
  default = true
}

#====================== Elastic IP
resource "aws_eip" "main_eip" {
  for_each = aws_instance.main
  instance   = each.value.id
  tags                   = {
    Name        = "${each.value.tags.Name} IP"
    Environment = each.value.tags.Environment
    Role        = "${each.value.tags.Name} IP"
    DC          = var.short_region
  }
}
