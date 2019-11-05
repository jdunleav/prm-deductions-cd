module "vpc" {
    source = "terraform-aws-modules/vpc/aws"

    name = "build-monitor-vpc"
    cidr = "10.90.0.0/16"

    azs             = ["eu-west-2a", "eu-west-2b"]
    private_subnets = ["10.90.1.0/24", "10.90.2.0/24"]
    public_subnets  = ["10.90.101.0/24", "10.90.102.0/24"]

    enable_vpn_gateway = false

    enable_nat_gateway = true
    single_nat_gateway = true
    one_nat_gateway_per_az = false

    tags = {
        Terraform = "true"
        Environment = "dev"
    }
}

provider "aws" {
  profile   = "default"
  version   = "~> 2.27"
  region    = "${var.aws_region}"
}