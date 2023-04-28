provider "aws" {
  region = var.init_region

  default_tags {
    tags = {
      Terraform   = true
      Environment = var.init_environment
      Project     = var.init_project
    }
  }
}

data "aws_eks_cluster_auth" "default" {
  name = aws_eks_cluster.this.name
}

provider "kubernetes" {
  host                   = aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.default.token

  # exec {
  #   api_version = "client.authentication.k8s.io/v1alpha1"
  #   command     = "aws"
  #   args = ["eks", "get-token", "--cluster-name", aws_eks_cluster.this.id]
  # }
}
