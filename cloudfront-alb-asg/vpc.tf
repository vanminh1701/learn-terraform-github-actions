

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"

  name = "${local.name}-vpc"
  cidr = "10.0.0.0/16"

  azs            = data.aws_availability_zones.available.names
  public_subnets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  enable_dns_hostnames = true
  enable_dns_support   = true
}
