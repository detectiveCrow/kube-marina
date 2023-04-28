##############
# Data Block #
##############
data "terraform_remote_state" "vpc" {
  backend = "remote"

  config = {
    organization = "kubernetes-marina"
    workspaces = {
      name = "aws-eks-vpc"
    }
  }
}

data "terraform_remote_state" "cluster" {
  backend = "remote"

  config = {
    organization = "kubernetes-marina"
    workspaces = {
      name = "aws-eks-cluster"
    }
  }
}
