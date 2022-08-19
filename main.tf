terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.0.0"
    }
  }
  // This is the required version of Terraform
  required_version = "~> 1.2.7"
}

provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "ubuntu" {
  most_recent = "true"

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_key_pair" "tutorial_kp" {
  key_name   = "tutorial_kp"
  public_key = file("tutorial_kp.pub")
}

resource "aws_eip" "tutorial_web_eip" {
  count    = var.settings.web_app.count
  instance = aws_instance.tutorial_web[count.index].id
  vpc      = true

  tags = {
    Name = "tutorial_web_eip_${count.index}"
  }
}