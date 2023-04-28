terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  cloud {
    organization = "kubernetes-marina"

    workspaces {
      name = "aws-eks-instance"
    }
  }
}
