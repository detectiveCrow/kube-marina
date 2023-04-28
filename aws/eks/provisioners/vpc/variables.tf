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

variable "vpc_cidr" {
  description = "cidr value which vpc will placement"
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 32))
    error_message = "Must be valid IPv4 CIDR"
  }
}

variable "cluster_name" {
  description = "eks cluster name"
  type        = string
}
