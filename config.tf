provider "aws" {
  profile = "default"
  version = "~> 2.27"
  region  = var.aws_region
}