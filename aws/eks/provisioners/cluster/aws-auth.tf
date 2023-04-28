locals {
  default_auth = {
    rolearn  = aws_iam_role.eks_basic.arn
    username = "system:node:{{EC2PrivateDNSName}}"
    groups = [
      "system:bootstrappers",
      "system:nodes",
    ]
  }
  bastion_auth = {
    rolearn  = aws_iam_role.bastion.arn
    username = "cluster-admin"
    groups = [
      # REF: https://kubernetes.io/ja/docs/reference/access-authn-authz/rbac/
      "system:masters",
    ]
  }
}

#########################
# Config Map - aws-auth #
#########################
resource "kubernetes_config_map_v1_data" "bastion" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  force = true

  data = {
    mapRoles = yamlencode([
      local.default_auth,
      local.bastion_auth,
    ])
  }

  depends_on = [
    aws_eks_cluster.this,
    aws_eks_node_group.medium,
    aws_eks_node_group.large,
  ]
}
