output "vpc_id" {
  description = "id of created vpc"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "list of ids of public subnets"
  value       = module.vpc.public_subnets
}

output "private_subnet_ids" {
  description = "list of ids of private subnets"
  value       = module.vpc.private_subnets
}
