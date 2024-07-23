###############################################################################
# Terraform
###############################################################################
terraform {
  required_version = "~> 1.8.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.42.0"
    }
  }
  backend "s3" {
    bucket  = "accounts-terraform-state-bucket"
    key     = "accounts-terraform.tfstate"
    region  = "us-east-2"
    encrypt = true
  }
}

provider "aws" {
  profile = "root"
  region  = "us-east-2"
}
