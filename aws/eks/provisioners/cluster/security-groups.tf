###############
# EKS Cluster #
###############
resource "aws_security_group" "eks_cluster" {
  name   = "${var.init_project}-${var.init_environment}-eks-cluster"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    "Name" = "${var.init_project}-${var.init_environment}-eks-cluster"
  }
}

# resource "aws_security_group" "eks_node_group_small" {
#   name_prefix = "${var.init_project}-${var.init_environment}-eks-node-group-small"
#   vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

#   ingress {
#     from_port = 0
#     to_port   = 0
#     protocol  = "-1"
#     cidr_blocks = [ "0.0.0.0/0" ]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   egress {
#     from_port = 0
#     to_port   = 0
#     protocol  = "-1"
#     cidr_blocks = [ "0.0.0.0/0" ]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   tags = {
#     "Name" = "${var.init_project}-${var.init_environment}-eks-node-group-small"
#   }
# }

# resource "aws_security_group" "eks_node_group_medium" {
#   name_prefix = "${var.init_project}-${var.init_environment}-eks-node-group-medium"
#   vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

#   ingress {
#     from_port = 0
#     to_port   = 0
#     protocol  = "-1"
#     cidr_blocks = [ "0.0.0.0/0" ]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   egress {
#     from_port = 0
#     to_port   = 0
#     protocol  = "-1"
#     cidr_blocks = [ "0.0.0.0/0" ]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   tags = {
#     "Name" = "${var.init_project}-${var.init_environment}-eks-node-group-medium"
#   }
# }
