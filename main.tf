terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.2.0"
    }
  }
}

# #To use the VPC module already created
# module "aws_glue" {
#   source    = "git@github.com:satishkumarkrishnan/terraform-aws-vpc.git?ref=main"   
# }