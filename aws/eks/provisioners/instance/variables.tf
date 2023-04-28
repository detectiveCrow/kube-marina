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

variable "bastion_ami" {
  description = "ami id of bastion"
  type        = string
  default     = "ami-09d3b3274b6c5d4aa" # Amazon Linux 2 AMI (us-east-1)
}

variable "bastion_instance_type" {
  description = "instance type of bastion"
  type        = string
  default     = "t3.small"
}

variable "bastion_keyname" {
  description = "keyname which use for bastion access"
  type        = string
}
