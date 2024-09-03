# terraform {
#   cloud {
#     organization = "Satish_Terraform"

#     workspaces {
#       name = "Terraform_Final"
#     }
#   }
# }
#Adding a region
provider "aws" {
  region = var.region
}