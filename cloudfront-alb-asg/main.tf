
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
  name = "demo"
}

resource "random_pet" "sg" {}

data "aws_availability_zones" "available" {
  state = "available"
}