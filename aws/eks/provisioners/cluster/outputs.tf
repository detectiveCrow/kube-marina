locals {
  kubeconfig = templatefile("./template/kubeconfig.tpl", {
    kubeconfig_name     = var.cluster_name
    endpoint            = aws_eks_cluster.this.endpoint
    cluster_auth_base64 = aws_eks_cluster.this.certificate_authority[0].data
    user_exec_command   = "aws"
    user_exec_args = [
      "--region",
      var.init_region,
      "eks",
      "get-token",
      "--cluster-name",
      var.cluster_name,
    ]
    # get token with `aws eks get-token` command
  })
}

output "kubeconfig" {
  description = "yaml value of kubeconfig"
  value       = local.kubeconfig
}

output "aws_iam_role" {
  description = "created aws iam role"
  value = {
    bastion = aws_iam_role.bastion
  }
}
