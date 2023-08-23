
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
  }
  required_version = "~> 1.0"
}

provider "aws" {
  region                   = "us-east-1"
  shared_credentials_files = ["/home/minh/.aws/credentials"]
}

locals {
  tags = {
    "Project"   = "Demo"
    "ManagedBy" = "tvminh"
  }

  name     = "demo"
  subnet_ids = ["subnet-0b085e23fc3e4138c", "subnet-08bf98817f0bdae5f"]

}

data "aws_vpc" "default" {
  default = true
}



