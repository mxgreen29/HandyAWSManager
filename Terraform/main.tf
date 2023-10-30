terraform {
  required_providers {
    aws = {
      version = "5.5.0"
      source  = "hashicorp/aws"
    }
  }
}
locals {
  instance_name = [
  for key, i in var.instance : {
    name = i.name
    pub_ip = aws_eip.main_eip[key].public_ip
  }
  ]
  public_ips = [
    for ip in aws_eip.main_eip : {
    ip = ip.public_ip
}
  ]
  ips = tolist(flatten([for k, i in local.public_ips : i.ip ]))
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      StartedBy = "Terraform"
    }
  }
}

terraform {
  backend "s3" {
    bucket         = ""
    key            = "states/terraform.tfstate"
#    dynamodb_table = "terraform-state-locking"
    region         = "us-east-1"
  }
}


data "aws_region" "current" {}

provider "local" {
  version = "~> 2.2.3"
}

provider "template" {
  version = "~> 2.2"
}
