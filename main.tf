
/**
  VPC with public subnet
  ASG + launch ec2 configure + Target group
  security group for ec2 and ALB
  Cloudfront with custom ACM
*/

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.11.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }

  }
  required_version = "~> 1.0"
}

provider "aws" {
  region                   = "us-east-1"
  shared_credentials_files = ["/home/minh/.aws/credentials"]
}

locals {
  tags = {
    "Project"   = "demo"
    "ManagedBy" = "tvminh"
  }
}

resource "random_pet" "sg" {}


resource "aws_security_group" "web-sg" {
  name = "${random_pet.sg.id}-sg"

  # dynamic "ingress" {
  #   for_each = var.sg_inbound_rules

  #   content {
  #     from_port   = ingress.value["port"]
  #     to_port     = ingress.value["port"]
  #     protocol    = ingress.value["proto"]
  #     cidr_blocks = ingress.value["cidr_blocks"]
  #   }
  # }

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb-sg.id]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group" "alb-sg" {
  name = "demo-alb-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = module.vpc.vpc_id
}
