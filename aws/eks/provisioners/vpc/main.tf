module "current_region" {
  source = "git::https://github.com/terraform-toybox/terraform-aws-region?ref=v1.0.0"
}

#######
# VPC #
#######
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = join("-", [var.init_project, var.init_environment, "vpc"])

  cidr = var.vpc_cidr // ex) vpc_cidr = 10.0.0.0/16
  azs  = module.current_region.availability_zone_names

  public_subnets          = cidrsubnets(cidrsubnet(var.vpc_cidr, 2, 0), 2, 2) // ex) public = 10.0.0.0/18 | 10.0.0.0/20, 10.0.0.16/20
  private_subnets         = cidrsubnets(cidrsubnet(var.vpc_cidr, 2, 2), 2, 2) // ex) private = 10.0.128.0/18 | 10.0.128.0/20, 10.0.144.0/20
  map_public_ip_on_launch = false

  # NAT
  enable_nat_gateway     = true
  single_nat_gateway     = true
  enable_dns_hostnames   = true
  one_nat_gateway_per_az = false

  # VPN
  enable_vpn_gateway = false

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "kubernetes.io/role/internal-elb"           = 1
  }
}
