##############
# Data Block #
##############
data "terraform_remote_state" "vpc" {
  # https://developer.hashicorp.com/terraform/language/state/remote-state-data
  backend = "remote"

  config = {
    organization = "kubernetes-marina"
    workspaces = {
      name = "aws-eks-vpc"
    }
  }
}

###############
# EKS Cluster #
###############
resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  version  = "1.23"
  role_arn = aws_iam_role.eks_basic.arn

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = true
    subnet_ids              = data.terraform_remote_state.vpc.outputs.private_subnet_ids
    security_group_ids      = [aws_security_group.eks_cluster.id]
  }

  kubernetes_network_config {
    service_ipv4_cidr = "172.16.0.0/16"
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_security_group.eks_cluster,
    aws_iam_role_policy_attachment.eks_amazon_eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_amazon_eks_vpc_resource_controller,
  ]
}

#######################
# Node Group - medium #
#######################
resource "aws_eks_node_group" "medium" {
  cluster_name = aws_eks_cluster.this.name

  node_group_name = "${aws_eks_cluster.this.name}-medium"
  node_role_arn   = aws_iam_role.eks_basic.arn
  subnet_ids      = data.terraform_remote_state.vpc.outputs.private_subnet_ids

  disk_size      = 32
  instance_types = ["t3.medium"]

  scaling_config {
    desired_size = 2
    max_size     = 4
    min_size     = 2
  }

  update_config {
    max_unavailable = 2
  }

  tags = {
    "kubernetes.io/cluster/${aws_eks_cluster.this.name}" = "owned",
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks_amazon_eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_amazon_eks_cni_policy,
    aws_iam_role_policy_attachment.eks_amazon_ec2_container_registry_read_only,
  ]

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}

######################
# Node Group - large #
######################
resource "aws_eks_node_group" "large" {
  cluster_name = aws_eks_cluster.this.name

  node_group_name = "${aws_eks_cluster.this.name}-large"
  node_role_arn   = aws_iam_role.eks_basic.arn
  subnet_ids      = data.terraform_remote_state.vpc.outputs.private_subnet_ids

  disk_size      = 32
  instance_types = ["t3.large"]

  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 1
  }

  update_config {
    max_unavailable = 2
  }

  tags = {
    "kubernetes.io/cluster/${aws_eks_cluster.this.name}" = "owned",
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks_amazon_eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_amazon_eks_cni_policy,
    aws_iam_role_policy_attachment.eks_amazon_ec2_container_registry_read_only,
  ]

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}
