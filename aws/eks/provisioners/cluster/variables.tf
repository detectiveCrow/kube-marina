variable "init_region" {
  description = "region name which resources will placement"
  type        = string
  default     = "us-east-1"
}

variable "init_environment" {
  description = "environment value"
  type        = string
  default     = "test"
}

variable "init_project" {
  description = "project name"
  type        = string
  default     = "cb"
}

variable "cluster_name" {
  description = "eks cluster name"
  type        = string
}
