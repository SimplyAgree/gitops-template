terraform {
  backend "s3" {
    bucket = "k1-state-store-devops-kaztp4"
    key    = "terraform/aws/terraform.tfstate"

    region  = "<CLOUD_REGION>"
    encrypt = true
  }
}


provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      ClusterName   = "<CLUSTER_NAME>"
      ProvisionedBy = "kubefirst"
    }
  }
}

module "eks" {
  source = "./eks"
}

resource "aws_iam_role_policy_attachment" "vcluster_external_dns" {
  role       = module.eks.node_iam_role_name
  policy_arn = module.eks.external_dns_policy_arn
}

module "kms" {
  source = "./kms"
}

module "dynamodb" {
  source = "./dynamodb"
}

