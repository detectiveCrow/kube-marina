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
